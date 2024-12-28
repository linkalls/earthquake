import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "dart:io";
import 'package:permission_handler/permission_handler.dart';
import "package:go_router/go_router.dart";

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Settings extends HookWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = useState<bool?>(null);

    useEffect(() {
      Future<void> loadSettings() async {
        final preferences = await SharedPreferences.getInstance();
        settings.value = preferences.getBool("settings") ?? false;
      }

      Future<void> initializeNotifications() async {
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        final InitializationSettings initializationSettings =
            InitializationSettings(
          android: initializationSettingsAndroid,
        );

        await flutterLocalNotificationsPlugin
            .initialize(initializationSettings);
      }

      loadSettings();
      initializeNotifications();

      return null;
    }, []);

    if (settings.value == null) {
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
        title: const Text('設定'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 17, 18, 20),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SwitchListTile(
                value: settings.value!,
                onChanged: (value) async {
                  final preferences = await SharedPreferences.getInstance();
                  await preferences.setBool("settings", value);
                  settings.value = value;

                  if (value && Platform.isAndroid) {
                    var status = await Permission.notification.status;
                    if (!status.isGranted || status.isRestricted) {
                      status = await Permission.notification.request();
                      if (status.isGranted) {
                        await _showNotification(
                            title: "通知を有効化しました", context: "通知を受け取るようになりました");
                      } else if (status.isPermanentlyDenied) {
                        // ユーザーに設定画面を開くように促す
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('通知の許可が必要です'),
                            content:
                                const Text('通知を受け取るには、設定画面で通知の許可を有効にしてください。'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await openAppSettings();
                                },
                                child: const Text('設定を開く'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigator.of(context).pop();
                                  context.pop('/settings');
                                },
                                child: const Text('キャンセル'),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      await _showNotification(
                          title: "通知を有効化しました", context: "通知を受け取るようになりました");
                    }
                  }
                },
                title: const Text("バックグラウンド通知を受け取る"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showNotification(
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
}
