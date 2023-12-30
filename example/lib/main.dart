import 'package:flutter/material.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
                  (data) {
                    print(data);
                    KingCache.storeLog('Response: $data');
                  },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
