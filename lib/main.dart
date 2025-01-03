import 'package:flutter/material.dart';
import 'package:earthquake/earthquake.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:go_router/go_router.dart';
import "package:earthquake/router.dart";
import "package:workmanager/workmanager.dart";
import "dart:math";

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print(
        "Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   Workmanager().initialize(
//       callbackDispatcher, // The top level function, aka callbackDispatcher
//       isInDebugMode:
//           true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
//       );

//   // One-off task to run immediately
//   // Workmanager().registerOneOffTask(
//   //   "${Random().nextInt(10100000)}", //* ここは他と被っちゃだめ
//   //   "fetchEarthquakeData",
//   // );
//   Workmanager().registerPeriodicTask(
//     "2",
//     "fetchEarthquakeData",
//     frequency: const Duration(minutes: 15),
//   );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
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
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text('地震情報'),
      //     centerTitle: true,
      //     backgroundColor: const Color.fromARGB(255, 17, 18, 20),
      //   ),
      //   body: SafeArea(
      //     child: _EarthQuake(),
      //   ),
      // ),
    );
  }
}

class EarthQuake extends HookWidget {
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
      //* なかったときのローディング画面
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.blue,
            size: 40,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('地震情報'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 17, 18, 20),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
                onPressed: () {
                  context.push("/settings");
                },
                icon: const Icon(Icons.settings)),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            print("hello");
            earthquakes.value = await fetchEarthquakes();
          },
          child: Center(
            child: ListView.builder(
              itemCount: earthquakes.value.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          '情報名: ${earthquakes.value[index].ttl}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "発生日時: ${earthquakes.value[index].getFormattedDate()}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            final url =
                                googleMapsUrl(earthquakes.value[index].anm);
                            launchUrl(Uri.parse(url));
                          },
                          child: Text(
                            '震源地名: ${earthquakes.value[index].anm}',
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 20),
                          ),
                        ),
                        SelectableText(
                          'マグニチュード: ${earthquakes.value[index].mag}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        SelectableText(
                          '最大震度: ${earthquakes.value[index].maxi}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         InfoPage(earthquakes.value[index].json),
                            //   ),
                            // );
                            context
                                .push("/info/${earthquakes.value[index].json}");
                          },
                          child: const Text("詳細をみる"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<Earthquake>> fetchEarthquakes() async {
  final dio = Dio();
  dio.interceptors.add(RetryInterceptor(
    dio: dio,
    logPrint: print, // specify log function (optional)
    retries: 3, // retry count (optional)
    retryDelays: const [
      // set delays between retries (optional)
      Duration(seconds: 1), // wait 1 sec before first retry
      Duration(seconds: 2), // wait 2 sec before second retry
      Duration(seconds: 3), // wait 3 sec before third retry
    ],
  ));
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
