import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:king_cache/king_cache.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  bool isSupported = false;

  @override
  void initState() {
    super.initState();
    AnalyticsEngine.init('0')
        .catchError((_) => setState(() => isSupported = false))
        .then((_) => setState(() => isSupported = true));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Analytics Page')),
        body: isSupported
            ? ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: const Text('Log Api Error'),
                      onPressed: () {
                        AnalyticsEngine.apiError({
                          'error': 'Sample API error',
                          'code': 500,
                          'endpoint': '/sample-endpoint',
                        });
                      },
                    ),
                  )
                ],
              )
            : const Center(
                child: Text('Analytics not supported'),
              ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isSupported', isSupported));
  }
}
