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
   List<Earthquake> earthquakes = jsonResponse.map((item) => Earthquake.fromJson(item)).toList();
   earthquakes.sort((a, b) => b.time.compareTo(a.time)); // Sort by time in descending order
   return earthquakes.take(20).toList(); // Take the first 20 items
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

String formatDateTime(String? dateStr) {
 if (dateStr == null || dateStr.isEmpty) {
 return '';
 }
 try {
 var inputFormat = DateFormat("yyyyMMddHHmmss");
 var outputFormat = DateFormat("yyyy-MM-dd-HH:mm"); // Changed format here
 var parsedDate = inputFormat.parse(dateStr);
 return outputFormat.format(parsedDate);
 } catch (e) {
 // ignore: avoid_print
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
// ignore: avoid_print
if (snapshot.hasError) print(snapshot.error);
         return snapshot.hasData
  ? ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        int reversedIndex = snapshot.data!.length - 1 - index;
        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('日時: ${formatDateTime(snapshot.data![reversedIndex].ctt)}'),
              Text('震央地名: ${snapshot.data![reversedIndex].anm}'),
              Text('マグニチュード: ${snapshot.data![reversedIndex].mag}'),
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