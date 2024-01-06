// ignore_for_file: unused_element, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '地震情報',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const _EarthquakePage(),
    );
  }
}

Future<List<Earthquake>> fetchEarthquakes() async {
  final response = await http
      .get(Uri.parse('https://www.jma.go.jp/bosai/quake/data/list.json'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((item) => Earthquake.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load earthquake data');
  }
}

class _EarthquakePage extends StatefulWidget {
  const _EarthquakePage({super.key});

  @override
  _EarthquakePageState createState() => _EarthquakePageState();
}

class _EarthquakePageState extends State<_EarthquakePage> {
  List<Earthquake> earthquakes = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    earthquakes = await fetchEarthquakes();
    setState(() {});
  }

  Future<void> refreshEarthquakes() async {
    List<Earthquake> newEarthquakes = await fetchEarthquakes();
    setState(() {
      earthquakes.insertAll(
          0, newEarthquakes); // Add new data at the top of the list
      // Assuming you want to keep a maximum of 50 items in the list
      if (earthquakes.length > 50) {
        earthquakes = earthquakes.sublist(0, 50);
      }
    });
  }

  String formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return '';
    }
    try {
      var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
      var outputFormat = DateFormat("yyyy年MM月dd日HH時mm分");
      var parsedDate = inputFormat.parse(dateStr);
      return outputFormat.format(parsedDate);
    } catch (e) {
      // ignore: avoid_print
      print('Error parsing date: $e');
      return dateStr; // パース失敗時は元の文字列を返す
    }
  }

  Future<void> launchUrl(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地震情報'),
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Modified from',
                        style: DefaultTextStyle.of(context).style.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 8.0),
                      ),
                      TextSpan(
                        text: 'Earthquake information',
                        style: const TextStyle(
                            color: Colors.lightBlue, fontSize: 8.0),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                'https://www.jma.go.jp/bosai/#lang=en&pattern=earthquake_volcano'));
                          },
                      ),
                      TextSpan(
                        text: ' provided by\n ',
                        style: DefaultTextStyle.of(context).style.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 8.0),
                      ),
                      TextSpan(
                        text: 'JMA',
                        style: const TextStyle(
                            color: Colors.lightBlue, fontSize: 8.0),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                'https://www.jma.go.jp/jma/index.html'));
                          },
                      ),
                      TextSpan(
                        text: '. Details can be found on the JMA website.',
                        style: DefaultTextStyle.of(context).style.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 8.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshEarthquakes,
        child: ListView.builder(
          itemCount: earthquakes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                        '日時: ${formatDateTime(earthquakes[index].rdt)}',
                        style: const TextStyle(fontSize: 18)),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontSize: 18),
                        children: <TextSpan>[
                          const TextSpan(text: '震央地名: '),
                          TextSpan(
                            text: earthquakes[index].anm,
                            style: const TextStyle(color: Colors.lightBlue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                final query =
                                    Uri.encodeComponent(earthquakes[index].anm);
                                final googleMapsUrl =
                                    "https://www.google.com/maps/search/?api=1&query=$query";
                                launchUrl(Uri.parse(googleMapsUrl));
                              },
                          ),
                        ],
                      ),
                    ),
                    SelectableText('マグニチュード: ${earthquakes[index].mag}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    final earthquakeInfo =
                        '日時: ${formatDateTime(earthquakes[index].rdt)}\n'
                        '震央地名: ${earthquakes[index].anm}\n'
                        'マグニチュード: ${earthquakes[index].mag}\n'
                        'https://地震.net'; // ここにURLを追加
                    Share.share(earthquakeInfo);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
