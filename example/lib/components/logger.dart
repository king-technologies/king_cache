import 'package:flutter/material.dart';
import 'package:king_cache/king_cache.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Logger Page')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                await KingCache().storeLog('Call Json Place Holder API');
                final x = await KingCache().getLogs;
                debugPrint(x);
              },
              child: const Text('Store & Get Log  '),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async => debugPrint(await KingCache().getLogs),
              child: const Text('Get Logs'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => KingCache().clearLog,
              child: const Text('Clear Logs'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => KingCache().clearAllCache,
              child: const Text('Clear All Cache'),
            ),
          ),
        ]),
      );
}
