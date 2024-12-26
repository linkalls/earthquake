import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import "package:dio/dio.dart";

class InfoPage extends HookWidget {
  const InfoPage(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    final earthquake = useState<Map<String, dynamic>?>(null);

    useEffect(() {
      final dio = Dio();
      final url = 'https://www.jma.go.jp/bosai/quake/data/$name';
      dio.get(url).then((response) {
        final Map<String, dynamic> earthquakeData = response.data;
        earthquake.value = earthquakeData;
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('地震情報'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 17, 18, 20),
      ),
      body: SafeArea(
        child: Center(
          child: earthquake.value != null
              ? Column(
                  //* nullでない場合
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      earthquake.value?['Head']?['Headline']?['Text'] ??
                          '見つかりませんでした',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    SelectableText(
                      earthquake.value?["Body"]?["Comments"]?['ForecastComment']
                              ?['Text'] ??
                          '見つかりませんでした',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                )
              : const CircularProgressIndicator(), //* nullの場合
        ),
      ),
    );
  }
}
