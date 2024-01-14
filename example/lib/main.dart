import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  KingCache.setBaseUrl('https://jsonplaceholder.typicode.com/');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'King Cache Example',
        theme: ThemeData(),
        home: const MyHomePage(title: 'King Cache Example'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    KingCache.setHeaders({'Content-Type': 'application/json'});
    KingCache.appendFormData({'token': '1234567890'});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  await KingCache.storeLog('Call Json Place Holder API');
                  await KingCache.cacheViaRest(
                    'todos/1',
                    onSuccess: (data) {
                      debugPrint(data.toString());
                      KingCache.storeLog('Response: $data');
                    },
                    onError: (data) => debugPrint(data.message),
                    apiResponse: (data) => debugPrint(data.message),
                    isCacheHit: (isHit) => debugPrint('Is Cache Hit: $isHit'),
                    shouldUpdate: true,
                    expiryTime: DateTime.now().add(const Duration(hours: 1)),
                  );
                  await KingCache.storeLog('Call Json Place Holder API');
                },
                child: const Text('Json Place Holder API'),
              ),
              TextButton(
                onPressed: () async {
                  debugPrint(await KingCache.getLogs);
                },
                child: const Text('Get Logs'),
              ),
              TextButton(
                onPressed: () => KingCache.getLogFile
                    .then((value) => debugPrint(value?.path)),
                child: const Text('Get Log File'),
              ),
              TextButton(
                onPressed: () => KingCache.clearLog,
                child: const Text('Clear Logs'),
              ),
              TextButton(
                onPressed: () => KingCache.clearAllCache,
                child: const Text('Clear All Cache'),
              ),
            ],
          ),
        ),
      );
}
