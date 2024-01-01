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
      debugShowCheckedModeBanner: false,
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
   earthquakes.sort((a, b) => a.time.compareTo(b.time)); // Sort by time in ascending order // Sort by time in descending order
   earthquakes = earthquakes.take(200).toList(); // Take the first 20 items
   return earthquakes;
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
var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
var outputFormat = DateFormat("yyyy年MM月dd日HH時mm分");
var parsedDate = inputFormat.parse(dateStr);
parsedDate = parsedDate.add(Duration(hours: 9)); // Convert to JST
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
     title: const Text(''),
   ),
   body: RefreshIndicator(
     onRefresh: () async {
       setState(() {
         futureEarthquakes = fetchEarthquakes();
       });
     },
     child: FutureBuilder<List<Earthquake>>(
       future: futureEarthquakes,
        builder: (BuildContext context, AsyncSnapshot<List<Earthquake>> snapshot) {
 if (snapshot.connectionState == ConnectionState.waiting) {
   return CircularProgressIndicator();
 } else if (snapshot.hasError) {
   return Text('Error: ${snapshot.error}');
 } else {
   return ListView.builder(
     itemCount: snapshot.data!.length,
     itemBuilder: (context, index) {
       int reversedIndex = snapshot.data!.length - 1 - index;
       return Card(
         margin: EdgeInsets.all(8),
         child: ListTile(
           title: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text('日時: ${formatDateTime(snapshot.data![reversedIndex].rdt)}', style: TextStyle(fontSize: 18)),
               Divider(),
               Text('震央地名: ${snapshot.data![reversedIndex].anm}', style: TextStyle(fontSize: 18)),
               Divider(),
               Text('マグニチュード: ${snapshot.data![reversedIndex].mag}', style: TextStyle(fontSize: 18)),
             ],
           ),
         ),
       );
     },
   );
 }
},
     ),
   ),
 );
}
}