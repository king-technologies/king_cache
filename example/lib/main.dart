import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:king_cache/king_cache.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'King Cache Example',
        home: MyHomePage(title: 'King Cache Example'),
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
    KingCache.setBaseUrl('https://jsonplaceholder.typicode.com/');
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
                  await KingCache().storeLog('Call Json Place Holder API');
                  await KingCache.cacheViaRest(
                    'todos/1',
                    onSuccess: (data) =>
                        KingCache().storeLog('Response: $data'),
                    onError: (data) => debugPrint('On Error: $data'),
                    apiResponse: (data) => debugPrint('Api Response: $data'),
                    isCacheHit: (isHit) => debugPrint('Is Cache Hit: $isHit'),
                    shouldUpdate: true,
                    expiryTime: DateTime.now().add(const Duration(hours: 1)),
                  );
                  await KingCache().storeLog('Call Json Place Holder API');
                },
                child: const Text('Json Place Holder API'),
              ),
              TextButton(
                onPressed: () async => debugPrint(await KingCache().getLogs),
                child: const Text('Get Logs'),
              ),
              TextButton(
                onPressed: () => KingCache().clearLog,
                child: const Text('Clear Logs'),
              ),
              TextButton(
                onPressed: () => KingCache().clearAllCache,
                child: const Text('Clear All Cache'),
              ),
            ],
          ),
        ),
      );
}
