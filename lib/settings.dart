import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Settings extends HookWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = useState<bool?>(null);

    useEffect(() {
      Future<void> loadSettings() async {
        final prefs = await SharedPreferences.getInstance();
        settings.value = prefs.getBool("settings") ?? false;
      }

      loadSettings();
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
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool("settings", value);
                  settings.value = value;
                  
                },
                title: const Text("バックグラウンド通知を受け取る"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
