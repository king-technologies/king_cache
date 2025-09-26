import 'package:flutter/material.dart';
import 'package:king_cache/king_cache.dart';

class NetworkCalls extends StatelessWidget {
  const NetworkCalls({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Network calls Page')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                final res = await KingCache.networkRequest(
                  'https://jsonplaceholder.typicode.com/todos/1',
                );
                if (res.status) {
                  debugPrint(res.data.toString());
                }
              },
              child: const Text('Make Network Call  '),
            ),
          ),
        ]),
      );
}
