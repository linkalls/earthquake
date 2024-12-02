import 'package:flutter/material.dart';

// import 'dart:convert';
import 'models.dart';
// import "package:intl/intl.dart";
// import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:share_plus/share_plus.dart';
import "package:dio/dio.dart";
import 'package:flutter_hooks/flutter_hooks.dart';
import "package:earthquake_net/info_page.dart";

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
        // home:  _EarthquakePage(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('地震情報'),
            centerTitle: true,
            backgroundColor: Colors.blue[900],
          ),
          body: SafeArea(
            child: _EarthQuake(),
          ),
        ));
  }
}

class _EarthQuake extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final earthquakes =
        useState<List<Earthquake>>([]); //* List型のearthquakesを作ってる
    useEffect(() {
      //* useEffectはasyncを使えないから.thenを使う
      //* 初回のみfetchEarthquakesを呼び出して_earthquakesに値を入れる
      fetchEarthquakes().then((fetchedEarthquakes) {
        earthquakes.value = fetchedEarthquakes;
      });
      return null; // Dispose function is not needed here
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
                  //* cardの中にpaddingを追加
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SelectableText('情報名: ${earthquakes.value[index].ttl}'),
                      GestureDetector(
                        //* GestureDetectorでタップイベントを追加
                        onTap: () {
                          final url =
                              googleMapsUrl(earthquakes.value[index].anm);
                          launchUrl(Uri.parse(url));
                        },
                        child: Text(
                          '震源地名: ${earthquakes.value[index].anm}',
                          style: const TextStyle(
                              color: Colors.blue), // リンクっぽく見せるために色を変更
                        ),
                      ),
                      SelectableText(
                          'マグニチュード: ${earthquakes.value[index].mag}'),
                      SelectableText('最大震度: ${earthquakes.value[index].maxi}'),
                      // Text(earthquakes.value[index].json),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InfoPage(earthquakes.value[index].json)),
                            );
                          },
                          child: const Text("詳細をみる")),
                    ],
                  ),
                )));
          }),
    ));
  }
}

// body: CustomScrollView(
//   slivers: <Widget>[
//     SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (BuildContext context, int index) {
//           return Container(
//             margin: const EdgeInsets.all(8),
//             child: Card(
//               child: Column(
//                 children: [
//                   Text('情報名: ${_earthquakes.value[index].ttl}'),
//                   Text('日時: ${_earthquakes.value[index].anm}'),
//                 ],
//               ),
//             ),
//           );
//         },
//         childCount: _earthquakes.value.length,
//       ),
//     ),
//   ],
// ),

Future<List<Earthquake>> fetchEarthquakes() async {
  final dio = Dio();
  final response =
      await dio.get("https://www.jma.go.jp/bosai/quake/data/list.json");
  //* jsonにしてる
  if (response.statusCode == 200) {
    List<dynamic> json = response.data; //* ここでlistにしてる
    // print(json);
    final earthquakes = json.map((item) => Earthquake.fromJson(
        item)); //* 一個一個のitemをEarthquake.fromJsonでEarthquakeに変換してる
    return earthquakes.toList();
    //* ここでリストにしてる こうしないとあとでListViewの時にエラーが出る
    //* List型ってのはjsonみたいな感じで[{},{}]のようになってる
  } else {
    throw Exception(
        'Failed to load earthquake data with status code: ${response.statusCode}');
  }
}

String googleMapsUrl(String anm) {
  final query = Uri.encodeComponent(anm);
  return "https://www.google.com/maps/search/?api=1&query=$query";
}

// Future<List<Earthquake>> fetchEarthquakes() async {
//   try {
//     final dio = Dio();
//     final response =
//         await dio.get('https://www.jma.go.jp/bosai/quake/data/list.json');
//     if (response.statusCode == 200) {
//       List<dynamic> jsonResponse = jsonDecode(response.data); // 修正箇所
//       return jsonResponse.map((item) => Earthquake.fromJson(item)).toList();
//     } else {
//       throw Exception(
//           'Failed to load earthquake data with status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('An error occurred while fetching earthquake data: $e');
//     throw Exception('Failed to fetch earthquake data');
//   }
// }

// class _EarthquakePage extends StatefulWidget {
//   const _EarthquakePage();

//   @override
//   _EarthquakePageState createState() => _EarthquakePageState();
// }

// class _EarthquakePageState extends State<_EarthquakePage> {
//   List<Earthquake> earthquakes = [];
//   @override
//   void initState() {
//     super.initState();
//     _loadInitialData();
//   }

//   Future<void> _loadInitialData() async {
//     earthquakes = await fetchEarthquakes();
//     setState(() {
//       earthquakes = earthquakes;
//     });
//   }

//   Future<void> refreshEarthquakes() async {
//     List<Earthquake> newEarthquakes = await fetchEarthquakes();
//     setState(() {
//       earthquakes.insertAll(
//           0, newEarthquakes); // Add new data at the top of the list
//       // Assuming you want to keep a maximum of 50 items in the list
//       if (earthquakes.length > 50) {
//         earthquakes = earthquakes.sublist(0, 50);
//       }
//     });
//   }

//   String formatDateTime(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty) {
//       return '';
//     }
//     try {
//       var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
//       var outputFormat = DateFormat("yyyy年MM月dd日HH時mm分");
//       var parsedDate = inputFormat.parse(dateStr);
//       return outputFormat.format(parsedDate);
//     } catch (e) {
//       return dateStr; // パース失敗時は元の文字列を返す
//     }
//   }

//   Future<void> openUrl(Uri url) async {
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('地震情報')),
//       body: RefreshIndicator(
//         onRefresh: refreshEarthquakes,
//         child: ListView.builder(
//           itemCount: earthquakes.length,
//           itemBuilder: (context, index) {
//             return Card(
//               margin: const EdgeInsets.all(8),
//               child: ListTile(
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SelectableText('情報名: ${earthquakes[index].ttl}', // ttlを表示
//                         style: const TextStyle(fontSize: 18)),
//                     SelectableText(
//                         '日時: ${formatDateTime(earthquakes[index].at)}',
//                         style: const TextStyle(fontSize: 18)),
//                     RichText(
//                       text: TextSpan(
//                         style: DefaultTextStyle.of(context)
//                             .style
//                             .copyWith(fontSize: 18),
//                         children: <TextSpan>[
//                           const TextSpan(text: '震央地名: '),
//                           TextSpan(
//                             text: earthquakes[index].anm,
//                             style: const TextStyle(color: Colors.lightBlue),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () {
//                                 final query =
//                                     Uri.encodeComponent(earthquakes[index].anm);
//                                 final googleMapsUrl =
//                                     "https://www.google.com/maps/search/?api=1&query=$query";
//                                 launchUrl(Uri.parse(googleMapsUrl));
//                               },
//                           ),
//                         ],
//                       ),
//                     ),
//                     SelectableText('マグニチュード: ${earthquakes[index].mag}',
//                         style: const TextStyle(fontSize: 18)),
//                     SelectableText('最大震度: ${earthquakes[index].maxi}',
//                         style: const TextStyle(fontSize: 18)),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.share),
//                   onPressed: () {
//                     final earthquakeInfo = '情報名: ${earthquakes[index].ttl}\n'
//                         '日時: ${formatDateTime(earthquakes[index].at)}\n'
//                         '震央地名: ${earthquakes[index].anm}\n'
//                         'マグニチュード: ${earthquakes[index].mag}\n';
//                     Share.share(earthquakeInfo);
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
