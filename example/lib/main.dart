import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'components/Analytics.dart';
import 'components/Cache.dart';
import 'components/info.dart';
import 'components/logger.dart';
import 'components/network_calls.dart';

const pageWidgets = <Widget>[
  InfoPage(),
  LogsPage(),
  NetworkCalls(),
  CachePage(),
  AnalyticsPage(),
];
const pages = [
  'Device Info',
  'Logger',
  'Network Calls',
  'Cache Management',
  'Analytics',
];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'King Cache Example',
        home: MyHomePage(title: 'King Cache Example'),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(25),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: pages.length,
          itemBuilder: (context, index) => Container(
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: [
                    BoxShadow(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0x3FFFFFFF)
                          : const Color(0x3F000000),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Material(
                  color: theme.scaffoldBackgroundColor,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                            builder: (context) => pageWidgets[index])),
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        pages[index],
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              )),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}
