part of '../king_cache.dart';

Future<String> getDeviceInfo() async {
  final info = DeviceInfoPlugin();
  var deviceInfo = <String, dynamic>{};
  if (kIsWeb) {
    deviceInfo = (await info.webBrowserInfo).data;
  } else {
    switch (Platform.operatingSystem) {
      case 'android':
        deviceInfo = (await info.androidInfo).data;
        break;
      case 'ios':
        deviceInfo = (await info.iosInfo).data;
        break;
      case 'linux':
        deviceInfo = (await info.linuxInfo).data;
        break;
      case 'macos':
        deviceInfo = (await info.macOsInfo).data;
        break;
      case 'windows':
        deviceInfo = (await info.windowsInfo).data;
        break;
      default:
    }
    deviceInfo.addAll({
      'OS': Platform.operatingSystem,
      'OS Version': Platform.version,
      'Host Name': Platform.localHostname,
      'Locale': Platform.localeName,
    });
  }
  return deviceInfo.entries
      .map((e) => '${e.key.toCapitalizedWords}: ${e.value}')
      .join(',\n');
}

Future<String> getDeviceName() async {
  var deviceName = '';
  final info = DeviceInfoPlugin();
  if (kIsWeb) {
    final webInfo = await info.webBrowserInfo;
    deviceName = webInfo.userAgent ?? 'Unknown';
  } else {
    switch (Platform.operatingSystem) {
      case 'android':
        final androidInfo = await info.androidInfo;
        deviceName = androidInfo.model;
        break;
      case 'ios':
        final iosInfo = await info.iosInfo;
        deviceName = iosInfo.name;
        break;
      case 'linux':
        final linuxInfo = await info.linuxInfo;
        deviceName = linuxInfo.name;
        break;
      case 'macos':
        final macInfo = await info.macOsInfo;
        deviceName = macInfo.computerName;
        break;
      case 'windows':
        final windowsInfo = await info.windowsInfo;
        deviceName = windowsInfo.computerName;
        break;
      default:
    }
  }
  return deviceName;
}

Future<String> getVersion() async {
  var versionInfo = '';
  final info = DeviceInfoPlugin();
  if (kIsWeb) {
    final webInfo = await info.webBrowserInfo;
    versionInfo = webInfo.appVersion ?? 'Unknown';
  } else {
    switch (Platform.operatingSystem) {
      case 'android':
        final androidInfo = await info.androidInfo;
        versionInfo = androidInfo.version.toString();
        break;
      case 'ios':
        final iosInfo = await info.iosInfo;
        versionInfo = iosInfo.systemVersion;
        break;
      case 'linux':
        final linuxInfo = await info.linuxInfo;
        versionInfo = linuxInfo.version ?? 'Unknown';
        break;
      case 'macos':
        final macInfo = await info.macOsInfo;
        versionInfo =
            '${macInfo.majorVersion}.${macInfo.minorVersion}.${macInfo.patchVersion}.${macInfo.kernelVersion}';
        break;
      case 'windows':
        final windowsInfo = await info.windowsInfo;
        versionInfo =
            '${windowsInfo.majorVersion}.${windowsInfo.minorVersion}.${windowsInfo.buildNumber}';
        break;
      default:
    }
  }
  return versionInfo;
}
