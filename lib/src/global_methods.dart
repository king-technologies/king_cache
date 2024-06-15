part of '../king_cache.dart';

bool get applicationDocumentSupport =>
    Platform.isAndroid ||
    Platform.isIOS ||
    Platform.isFuchsia ||
    Platform.isMacOS;

bool get firebaseCrashlyticsSupport => Platform.isAndroid || Platform.isIOS;

bool get windowManagerSupport =>
    Platform.isWindows || Platform.isLinux || Platform.isMacOS;

bool get isMobile => Platform.isAndroid || Platform.isIOS;

bool get isDesktop =>
    Platform.isWindows || Platform.isLinux || Platform.isMacOS;

bool get inAppUpdateSupport => Platform.isAndroid && kReleaseMode;

bool get githubApkReleaseSupport => Platform.isAndroid && kReleaseMode;

void ktShowToast(BuildContext context, String msg,
    {void Function()? trigger,
    String actionLabel = 'Undo',
    Color bgColor = const Color.fromRGBO(0, 20, 41, 0.494)}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      action: trigger != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: trigger,
            )
          : null,
    ),
  );
}

Future<bool> ktAuthenticateUser() async {
  try {
    final auth = LocalAuthentication();
    final isAuthAvailable = await auth.canCheckBiometrics;
    if (!isAuthAvailable) {
      return false;
    }
    return await auth.authenticate(
        localizedReason: 'Please authenticate to use the app');
  } on PlatformException catch (e) {
    debugPrint(e.toString());
    return true;
  }
}

Future<bool> ktRequestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    final result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

Future<({bool isUpdateAvailable, PackageInfo packageInfo})> ktCheckForUpdate(
    BuildContext context, String repo, String owner, String url) async {
  final packageInfo = await PackageInfo.fromPlatform();
  if (githubApkReleaseSupport) {
    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    final tag = 'v${version.substring(0, 4)}${int.parse(buildNumber) % 1000}';
    final httpClient = HttpClient();
    try {
      final request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      request.write(Uri(queryParameters: {
        'repo': 'kaushal',
        'owner': 'king-technologies',
      }).query);
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody) as Map<String, dynamic>;
        final networkTag = data['tag_name'] as String;
        if (tag != networkTag && context.mounted) {
          ktShowToast(context, 'New version available', trigger: () {
            launchUrl(
              Uri.parse(data['downloadUrl'] as String),
              mode: LaunchMode.externalApplication,
            );
          }, actionLabel: 'Download');
          return (isUpdateAvailable: true, packageInfo: packageInfo);
        }
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
      }
    } on Exception catch (e) {
      debugPrint('Exception: $e');
    } finally {
      httpClient.close();
    }
    return (isUpdateAvailable: false, packageInfo: packageInfo);
  }
  if (!inAppUpdateSupport) {
    return (isUpdateAvailable: false, packageInfo: packageInfo);
  }
  try {
    final info = await InAppUpdate.checkForUpdate();
    final isUpdateAvailable =
        info.updateAvailability == UpdateAvailability.updateAvailable;
    return (isUpdateAvailable: isUpdateAvailable, packageInfo: packageInfo);
  } on Exception catch (e) {
    debugPrint('Exception: $e');
  }
  return (isUpdateAvailable: false, packageInfo: packageInfo);
}

Future<void> flexibleUpdate() async {
  try {
    final info = await InAppUpdate.checkForUpdate();
    final isUpdateAvailable =
        info.updateAvailability == UpdateAvailability.updateAvailable;
    if (isUpdateAvailable) {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
    }
  } on Exception catch (e) {
    debugPrint('Exception: $e');
  }
}

Future<void> immediateUpdate() async {
  try {
    final info = await InAppUpdate.checkForUpdate();
    final isUpdateAvailable =
        info.updateAvailability == UpdateAvailability.updateAvailable;
    if (isUpdateAvailable) {
      await InAppUpdate.performImmediateUpdate();
    }
  } on Exception catch (e) {
    debugPrint('Exception: $e');
  }
}
