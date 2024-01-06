// ignore_for_file: deprecated_member_use, unused_element

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

  List<Earthquake> earthquakes = []; // Define earthquakes here

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    earthquakes =
        jsonResponse.map((item) => Earthquake.fromJson(item)).toList();
    // Rest of your code...
  } else {
    throw Exception('Failed to load earthquake data');
  }

  return earthquakes;
}

class _EarthquakePage extends StatefulWidget {
  const _EarthquakePage({super.key});

  @override
  _EarthquakePageState createState() => _EarthquakePageState();
}

class _EarthquakePageState extends State<_EarthquakePage> {
  late Future<List<Earthquake>> futureEarthquakes;

  @override
  void initState() {
    super.initState();
    futureEarthquakes = fetchEarthquakes();
  }

  Future<void> refreshEarthquakes() async {
    setState(() {
      futureEarthquakes = fetchEarthquakes();
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
      body: Stack(
        children: <Widget>[
          FutureBuilder<List<Earthquake>>(
            future: futureEarthquakes,
            builder: (BuildContext context,
                AsyncSnapshot<List<Earthquake>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return RefreshIndicator(
                  onRefresh: refreshEarthquakes,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                  '日時: ${formatDateTime(snapshot.data![index].rdt)}',
                                  style: const TextStyle(fontSize: 18)),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(
                                          fontSize:
                                              18), // Default text style with fontSize 18
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text:
                                            '震央地名: '), // "震央地名:" is not clickable and uses default style
                                    TextSpan(
                                      text: snapshot.data![index].anm,
                                      style: const TextStyle(
                                          color: Colors
                                              .lightBlue), // "石川県能登地方" is clickable and light blue
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          final query = Uri.encodeComponent(
                                              snapshot.data![index].anm);
                                          final googleMapsUrl =
                                              "https://www.google.com/maps/search/?api=1&query=$query";
                                          launchUrl(Uri.parse(googleMapsUrl));
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              SelectableText(
                                  'マグニチュード: ${snapshot.data![index].mag}',
                                  style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              final earthquakeInfo =
                                  '日時: ${formatDateTime(snapshot.data![index].rdt)}\n'
                                  '震央地名: ${snapshot.data![index].anm}\n'
                                  'マグニチュード: ${snapshot.data![index].mag}\n'
                                  'https://地震.net'; // Add the URL here
                              Share.share(earthquakeInfo);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
