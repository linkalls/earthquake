import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:dio/dio.dart";
import "package:shared_preferences/shared_preferences.dart";
import "dart:async"; //* Timerを使うために追加
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showNotification(
    {required String title, required String context}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'earthquake_channel_id',
    '地震情報',
    channelDescription: '地震情報を通知します',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    context,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

Future<void> fetchEarthquakeData() async {
  if (await Permission.notification.status.isGranted) {
    return;
  }
  final dio = Dio();
  final response =
      await dio.get('https://www.jma.go.jp/bosai/quake/data/list.json');
  final List<dynamic> earthquakeData = response.data;

  final prefs = await SharedPreferences.getInstance();
  final lastData = prefs.getString('lastEarthquakeData');

  if (lastData != response.data.last.toString()) {
    await prefs.setString('lastEarthquakeData', response.data.last.toString());
    await showNotification(
      title: '地震情報更新',
      context: '新しい地震情報があります。',
    );
    print('新しい地震情報があります。');
  }
}
