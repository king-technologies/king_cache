import 'package:flutter/material.dart';
import 'package:king_cache/king_cache.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Info Page')),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<String>(
                  future: getDeviceInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        spacing: 4,
                        children: [
                          Text('Device Information',
                              style: Theme.of(context).textTheme.titleLarge),
                          Text(snapshot.data ?? 'No device info available'),
                        ],
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: getVersion(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        spacing: 4,
                        children: [
                          Text('App Version',
                              style: Theme.of(context).textTheme.titleLarge),
                          Text('${snapshot.data}'),
                        ],
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: getDeviceName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        children: [
                          Text('Device Name',
                              style: Theme.of(context).textTheme.titleLarge),
                          Text('${snapshot.data}'),
                        ],
                      );
                    }
                  },
                ),
              ),
            ]),
      );
}
