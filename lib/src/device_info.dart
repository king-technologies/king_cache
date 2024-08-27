part of '../king_cache.dart';

Future<String> getDeviceInfo() async {
  final info = DeviceInfoPlugin();
  var deviceInfo = '';
  if (kIsWeb) {
    deviceInfo = 'Web: ${(await info.webBrowserInfo).data}';
  } else if (Platform.isAndroid) {
    deviceInfo = 'Android: ${(await info.androidInfo).data}';
    deviceInfo +=
        '${Platform.operatingSystem} ${Platform.version} ${Platform.localHostname} ${Platform.localeName}';
  } else if (Platform.isIOS) {
    deviceInfo = 'iOS: ${(await info.iosInfo).data}';
    deviceInfo +=
        '${Platform.operatingSystem} ${Platform.version} ${Platform.localHostname} ${Platform.localeName}';
  } else if (Platform.isLinux) {
    deviceInfo = 'Linux: ${(await info.linuxInfo).data}';
    deviceInfo +=
        '${Platform.operatingSystem} ${Platform.version} ${Platform.localHostname} ${Platform.localeName}';
  } else if (Platform.isMacOS) {
    deviceInfo = 'MacOS: ${(await info.macOsInfo).data}';
    deviceInfo +=
        '${Platform.operatingSystem} ${Platform.version} ${Platform.localHostname} ${Platform.localeName}';
  } else if (Platform.isWindows) {
    deviceInfo = 'Windows: ${(await info.windowsInfo).data}';
    deviceInfo +=
        '${Platform.operatingSystem} ${Platform.version} ${Platform.localHostname} ${Platform.localeName}';
  }
  return deviceInfo;
}

Future<int> getAndroidVersion() async {
  if (kIsWeb) {
    return 0;
  }
  if (!Platform.isAndroid) {
    return 0;
  }
  final info =  DeviceInfoPlugin();
  return int.tryParse((await info.androidInfo).version.release) ?? 0;
}
