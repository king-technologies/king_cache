import 'package:flutter/material.dart';
import 'package:king_cache/enums.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'King Cache Example',
      theme: ThemeData(),
      home: const MyHomePage(title: 'King Cache Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                KingCache.storeLog('Call Json Place Holder API');
                await KingCache.storeCacheViaRest(
                  'https://jsonplaceholder.typicode.com/todos/1',
                  method: HttpMethod.get,
                  onSuccess: (data) {
                    // This will execute 2 times when you have data in data
                    debugPrint(data);
                    KingCache.storeLog('Response: $data');
                  },
                  shouldUpdate: true,
                  expiryTime: DateTime.now().add(const Duration(seconds: 10)),
                );
                KingCache.storeLog('Call Json Place Holder API');
              },
              child: const Text('Json Place Holder API'),
            ),
            TextButton(
              onPressed: () async {
                debugPrint(await KingCache.getLog);
              },
              child: const Text('Get Logs'),
            ),
            TextButton(
              onPressed: () => KingCache.shareLogs,
              child: const Text('Share Logs'),
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
}
