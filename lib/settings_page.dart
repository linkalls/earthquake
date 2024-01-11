import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _backgroundFetchEnabled = false;
  bool _notificationsEnabled = false;
  bool _ignoreBatteryOptimizations = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _backgroundFetchEnabled =
          prefs.getBool('backgroundFetchEnabled') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      _ignoreBatteryOptimizations =
          prefs.getBool('ignoreBatteryOptimizations') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('backgroundFetchEnabled', _backgroundFetchEnabled);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setBool(
        'ignoreBatteryOptimizations', _ignoreBatteryOptimizations);
  }

  Future<void> _askBatteryOptimizationPermission() async {
    if (!_ignoreBatteryOptimizations) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('バッテリー最適化'),
          content: const Text('バックグラウンドでの実行を許可しますか？これにより、バッテリー最適化が無視されます。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('はい'),
            ),
          ],
        ),
      );

      if (result == true) {
        const AndroidIntent intent = AndroidIntent(
          action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
        );
        await intent.launch();
        setState(() {
          _ignoreBatteryOptimizations = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('バックグラウンドでデータ取得'),
            value: _backgroundFetchEnabled,
            onChanged: (bool value) async {
              if (value) {
                await _askBatteryOptimizationPermission();
              }
              setState(() {
                _backgroundFetchEnabled = value;
              });
              _saveSettings();
            },
          ),
          // 他の設定項目をここに追加
          ListTile(
            title: const Text('API提供元の情報'),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ProviderInfoPage(),
              ));
            },
          ),
        ],
      ),
    );
  }
}

class ProviderInfoPage extends StatelessWidget {
  const ProviderInfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API提供元の情報'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Modified from',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 12.0,
                ),
              ),
              TextSpan(
                text: ' Earthquake information',
                style: const TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 12.0,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchURL(
                        'https://www.jma.go.jp/bosai/#lang=en&pattern=earthquake_volcano',
                        context);
                  },
              ),
              TextSpan(
                text: ' provided by ',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 12.0,
                ),
              ),
              TextSpan(
                text: 'JMA',
                style: const TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 12.0,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchURL('https://www.jma.go.jp/jma/index.html', context);
                  },
              ),
              TextSpan(
                text: '. Details can be found on the JMA website.',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url, BuildContext context) async {
    final scaffoldMessenger =
        ScaffoldMessenger.of(context); // ここでScaffoldMessengerを取得
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      scaffoldMessenger.showSnackBar(
        // ここで取得したScaffoldMessengerを使用
        SnackBar(
          content: Text('Could not launch $url'),
        ),
      );
    }
  }
}
