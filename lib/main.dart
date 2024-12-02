import 'package:flutter/material.dart';
import 'models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:earthquake_net/info_page.dart';

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('地震情報'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: SafeArea(
          child: _EarthQuake(),
        ),
      ),
    );
  }
}

class _EarthQuake extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final earthquakes = useState<List<Earthquake>>([]);
    useEffect(() {
      fetchEarthquakes().then((fetchedEarthquakes) {
        earthquakes.value = fetchedEarthquakes;
      });
      return null;
    }, []);

    if (earthquakes.value.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(), // ローディング表示
      );
    }

    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: earthquakes.value.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.all(8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SelectableText('情報名: ${earthquakes.value[index].ttl}'),
                      GestureDetector(
                        onTap: () {
                          final url =
                              googleMapsUrl(earthquakes.value[index].anm);
                          launchUrl(Uri.parse(url));
                        },
                        child: Text(
                          '震源地名: ${earthquakes.value[index].anm}',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      SelectableText(
                          'マグニチュード: ${earthquakes.value[index].mag}'),
                      SelectableText('最大震度: ${earthquakes.value[index].maxi}'),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InfoPage(earthquakes.value[index].json),
                            ),
                          );
                        },
                        child: const Text("詳細をみる"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<List<Earthquake>> fetchEarthquakes() async {
  final dio = Dio();
  final response =
      await dio.get("https://www.jma.go.jp/bosai/quake/data/list.json");
  if (response.statusCode == 200) {
    List<dynamic> json = response.data;
    final earthquakes = json.map((item) => Earthquake.fromJson(item));
    return earthquakes.toList();
  } else {
    throw Exception(
        'Failed to load earthquake data with status code: ${response.statusCode}');
  }
}

String googleMapsUrl(String anm) {
  final query = Uri.encodeComponent(anm);
  return "https://www.google.com/maps/search/?api=1&query=$query";
}
