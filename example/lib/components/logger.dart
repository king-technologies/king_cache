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
                await CacheViaRestService.call(
                    'https://jsonplaceholder.typicode.com/todos/1');
              },
              child: const Text('Store Log'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async => debugPrint((await CacheViaRestService.call(
                      'https://jsonplaceholder.typicode.com/todos/1'))
                  .data
                  .toString()),
              child: const Text('Get API Log'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async => debugPrint(await CacheService.getLogs),
              child: const Text('Get Logs'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => CacheService.clearLogs,
              child: const Text('Clear Logs'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => CacheService.clearAllCache,
              child: const Text('Clear All Cache'),
            ),
          ),
        ]),
      );
}
