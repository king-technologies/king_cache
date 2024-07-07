part of '../king_cache.dart';

class AppVersionTag extends StatefulWidget {
  const AppVersionTag({super.key});

  @override
  State<AppVersionTag> createState() => _AppVersionTagState();
}

class _AppVersionTagState extends State<AppVersionTag> {
  String tag = '';

  @override
  void initState() {
    super.initState();
    if (tag.isEmpty) {
      ktGetPackageInfo.then((value) {
        tag = value.tag;
        if (value.packageInfo.packageName.endsWith('dev') ||
            value.packageInfo.packageName.endsWith('development')) {
          tag += '-dev';
        } else if (kDebugMode) {
          tag += ' (Debug)';
        } else if (kProfileMode) {
          tag += ' (Profile)';
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () => launchUrl(
          Uri(scheme: 'https', host: 'kingtechnologies.dev'),
          mode: LaunchMode.externalNonBrowserApplication,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Design & Developed by King Tech\nMade with 💝 in India $tag',
            style: theme.textTheme.headlineSmall!
                .copyWith(color: theme.colorScheme.secondary, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('tag', tag));
  }
}
