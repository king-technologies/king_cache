import 'package:flutter/material.dart';
import 'package:king_cache/king_cache.dart';

class CachePage extends StatelessWidget {
  const CachePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Cache Page')),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              const Text('Cache Cache'),
              ElevatedButton(
                onPressed: () {
                  CacheViaRestService.call(
                      'https://jsonplaceholder.typicode.com/todos/1',
                      onSuccess: (data) {
                    debugPrint('Data: $data');
                  }, onError: (error) {
                    debugPrint('Error: ${error.message}');
                  }, isCacheHit: (isHit) {
                    debugPrint('Is Cache Hit: $isHit');
                  },
                      expiryTime:
                          DateTime.now().add(const Duration(minutes: 10)));
                },
                child: const Text('Store Data in Cache'),
              ),
            ]),
      );
}
