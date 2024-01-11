import 'package:earthquake_net/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 通知プラグインのインスタンスを作成
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 通知の初期化設定
void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// 通知を表示する関数
Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'earthquake_update_channel', // チャネルID
    'Earthquake Updates', // チャネル名
    channelDescription:
        'Notification channel for earthquake updates', // チャネルの説明
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // 通知ID
    '更新情報', // 通知タイトル
    '地震情報が更新されました。', // 通知内容
    platformChannelSpecifics,
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'fetchEarthquakeData') {
      // 地震データをフェッチするロジックをここに追加
      List<Earthquake> isUpdated = await fetchEarthquakes();
      if (isUpdated.isNotEmpty) {
        // データが更新された場合は通知を表示
        await showNotification();
      }
    }
    return Future.value(true);
  });
}

void main() {
  initializeNotifications(); // 通知の初期化
  Workmanager().initialize(
    callbackDispatcher, // 上で定義したコールバック関数
    isInDebugMode: false, // デバッグモードをオフにする
  );
  Workmanager().registerPeriodicTask(
    '1',
    'fetchEarthquakeData',
    frequency: const Duration(minutes: 15), // 15分ごとに実行
    constraints: Constraints(
      networkType: NetworkType.connected, // インターネット接続が必要
    ),
  );
  runApp(const MyApp());
}

// 以下、MyAppクラスとその他のウィジェット、関数などのコード...

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
  try {
    final response = await http
        .get(Uri.parse('https://www.jma.go.jp/bosai/quake/data/list.json'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => Earthquake.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to load earthquake data with status code: ${response.statusCode}');
    }
  } catch (e) {
    // ここでエラーを処理する
    // ignore: avoid_print
    print('An error occurred while fetching earthquake data: $e');
    throw Exception('Failed to fetch earthquake data');
  }
}

class _EarthquakePage extends StatefulWidget {
  const _EarthquakePage();

  @override
  _EarthquakePageState createState() => _EarthquakePageState();
}

class _EarthquakePageState extends State<_EarthquakePage> {
  List<Earthquake> earthquakes = [];
  final Logger logger = Logger();

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
      logger.e('Error parsing date: $e');
      return dateStr; // パース失敗時は元の文字列を返す
    }
  }

  Future<void> openUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      logger.e('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地震情報'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingsPage(),
     ));
          },
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
                    SelectableText('情報名: ${earthquakes[index].ttl}', // ttlを表示
                        style: const TextStyle(fontSize: 18)),
                    SelectableText(
                        '日時: ${formatDateTime(earthquakes[index].at)}',
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
                    SelectableText('最大震度: ${earthquakes[index].maxi}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    final earthquakeInfo = '情報名: ${earthquakes[index].ttl}\n'
                        '日時: ${formatDateTime(earthquakes[index].at)}\n'
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
