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

 List<Earthquake> earthquakes = []; // Define earthquakes here

 if (response.statusCode == 200) {
   List<dynamic> jsonResponse = jsonDecode(response.body);
   earthquakes = jsonResponse.map((item) => Earthquake.fromJson(item)).toList();
   // Rest of your code...
 } else {
   throw Exception('Failed to load earthquake data');
 }

 return earthquakes;
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
      return Card(
        margin: EdgeInsets.all(8),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('日時: ${formatDateTime(snapshot.data![index].rdt)}', style: TextStyle(fontSize: 18)),
              Divider(),
              Text('震央地名: ${snapshot.data![index].anm}', style: TextStyle(fontSize: 18)),
              Divider(),
              Text('マグニチュード: ${snapshot.data![index].mag}', style: TextStyle(fontSize: 18)),
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