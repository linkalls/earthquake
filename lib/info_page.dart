import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import "package:dio/dio.dart";

class InfoPage extends HookWidget {
  InfoPage(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    final _earthquake = useState<Map<String, dynamic>?>(null);

    useEffect(() {
      final dio = Dio();
      final url = 'https://www.jma.go.jp/bosai/quake/data/${this.name}';
      dio.get(url).then((response) {
        final Map<String, dynamic> earthquakeData = response.data;
        _earthquake.value = earthquakeData;
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('地震情報'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: SafeArea(
        child: Center(
          child: _earthquake.value != null
              ? Column(
                  //* nullでない場合
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      _earthquake.value?['Head']?['Headline']?['Text'] ??
                          '見つかりませんでした',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    SelectableText(
                      _earthquake.value?["Body"]?["Comments"]
                              ?['ForecastComment']?['Text'] ??
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
