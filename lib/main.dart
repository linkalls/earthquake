import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthquake Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _EarthquakePage(),
    );
  }
}

Future<List<Earthquake>> fetchEarthquakes() async {
  final response = await http.get(Uri.parse('https://www.jma.go.jp/bosai/quake/data/list.json'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((item) => Earthquake.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load earthquake data');
  }
}

class _EarthquakePage extends StatefulWidget {
  const _EarthquakePage({Key? key}) : super(key: key);

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

String formatDateTime(String dateStr) {
  try {
    var inputFormat = DateFormat("yyyyMMddHHmmss");
    var outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    var parsedDate = inputFormat.parse(dateStr);
    return outputFormat.format(parsedDate);
  } catch (e) {
    print('Error parsing date: $e');
    return dateStr; // Return the original string if parsing fails
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake Data'),
      ),
      body: FutureBuilder<List<Earthquake>>(
        future: futureEarthquakes,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(child: Text(snapshot.data![index].anm)),
                          Text(snapshot.data![index].ctt),
                          Text(snapshot.data![index].mag),
                          Text(formatDateTime(snapshot.data![index].time)), // Fixed code
                        ],
                      ),
                    );
                  },
                )
              : const CircularProgressIndicator();
        },
      ),
    );
  }
}