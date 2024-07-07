part of '../king_cache.dart';

bool get applicationDocumentSupport =>
    Platform.isAndroid ||
    Platform.isIOS ||
    Platform.isFuchsia ||
    Platform.isMacOS;

bool get firebaseCrashlyticsSupport =>
    (Platform.isAndroid || Platform.isIOS) && kReleaseMode;

bool get windowManagerSupport =>
    Platform.isWindows || Platform.isLinux || Platform.isMacOS;

bool get isMobile => Platform.isAndroid || Platform.isIOS;

bool get isDesktop =>
    Platform.isWindows || Platform.isLinux || Platform.isMacOS;

bool get inAppUpdateSupport => Platform.isAndroid && kReleaseMode;

bool get githubApkReleaseSupport => Platform.isAndroid && kReleaseMode;

Future<bool> get ktLocallyAuthenticateUser async {
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

Future<
        ({
          bool isUpdateAvailable,
          PackageInfo packageInfo,
          String downloadUrl,
          String tag
        })>
    ktCheckForGithubReleaseUpdate(String repo, String owner, String url) async {
  final (:packageInfo, :tag) = await ktGetPackageInfo();
  var isUpdateAvailable = false;
  var downloadUrl = '';
  if (githubApkReleaseSupport) {
    final httpClient = HttpClient();
    try {
      final request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      request.write(Uri(queryParameters: {
        'repo': repo,
        'owner': owner,
      }).query);
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody) as Map<String, dynamic>;
        final networkTag = data['tag_name'] as String;
        if (tag != networkTag) {
          isUpdateAvailable = true;
          downloadUrl = data['downloadUrl'].toString();
        }
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
      }
    } on Exception catch (e) {
      debugPrint('Exception: $e');
    } finally {
      httpClient.close();
    }
  }
  return (
    tag: tag,
    isUpdateAvailable: isUpdateAvailable,
    packageInfo: packageInfo,
    downloadUrl: downloadUrl
  );
}

Future<bool> get ktCheckForPlayStoreUpdate async {
  if (inAppUpdateSupport) {
    final info = await InAppUpdate.checkForUpdate();
    return info.updateAvailability == UpdateAvailability.updateAvailable;
  }
  return false;
}

Future<void> ktFlexibleUpdate() async {
  if (!inAppUpdateSupport) {
    return;
  }
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

Future<({String tag, PackageInfo packageInfo})> ktGetPackageInfo() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final tag =
      'v${packageInfo.version.substring(0, 4)}${int.parse(packageInfo.buildNumber) % 1000}';
  return (tag: tag, packageInfo: packageInfo);
}

Future<void> ktImmediateUpdate() async {
  if (!inAppUpdateSupport) {
    return;
  }
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


double getTextWidth(BuildContext context, String text, TextStyle? style) {
  final span = TextSpan(text: text, style: style);
  const constraints = BoxConstraints();
  final richTextWidget = Text.rich(span).build(context) as RichText;
  final renderObject = richTextWidget.createRenderObject(context);
  renderObject.layout(constraints);
  final renderBoxes = renderObject.getBoxesForSelection(
    TextSelection(
      baseOffset: 0,
      extentOffset: TextSpan(text: text).toPlainText().length,
    ),
  );
  return renderBoxes.last.right;
}
