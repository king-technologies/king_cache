library king_cache;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'enums.dart';
import 'network_request.dart';
import 'response_model.dart';

class KingCache {
  factory KingCache() => _instance;

  KingCache._internal();

  static final KingCache _instance = KingCache._internal();

  static Future<ResponseModel> storeCacheViaRest(
    String url, {
    // ignore: avoid_annotating_with_dynamic
    required void Function(dynamic data) onSuccess,
    HttpMethod method = HttpMethod.get,
    Map<String, dynamic>? formData,
    Map<String, String> headers = const {'Content-Type': 'application/json', 'Accept': 'application/json'},
    bool shouldUpdate = false,
    DateTime? expiryTime,
  }) async {
    final fileName = url.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    var file = await KingCache.localFile(fileName);
    var gotData = false;
    if (file.existsSync()) {
      final data = file.readAsStringSync();
      if (data.isNotEmpty) {
        gotData = true;
        onSuccess(data);
      }
    }
    if (gotData && !shouldUpdate) {
      return const ResponseModel(status: true, message: 'Got data from cache');
    }

    // Check if the cache has expired
    if (expiryTime != null && DateTime.now().isAfter(expiryTime)) {
      file.deleteSync();
      file = await KingCache.localFile(fileName);
    }

    final res = await networkRequest(url, formData: formData, method: method, headers: headers);
    if (res.status) {
      file.writeAsStringSync(res.data.toString());
      onSuccess(res.data);
    }
    return res;
  }

  static Future<File> localFile(String fileName) async {
    final path = await getApplicationCacheDirectory();
    if (path.path.isNotEmpty) {
      final file = File('${path.path}/$fileName');
      if (file.existsSync()) {
        return file;
      }
    }
    return File('${path.path}/$fileName').create(recursive: true);
  }

  // Store log in cache
  static Future<void> storeLog(String log) async {
    final file = await KingCache.localFile(FilesTypes.log.file);
    if (file.existsSync()) {
      final data = file.readAsStringSync();
      if (data.isNotEmpty) {
        file.writeAsStringSync('$data\n$log');
      } else {
        file.writeAsStringSync(log);
      }
    } else {
      file.writeAsStringSync(log);
    }
  }

  // Get log from cache
  static Future<String> get getLog async {
    final file = await KingCache.localFile(FilesTypes.log.file);
    if (file.existsSync()) {
      final data = file.readAsStringSync();
      if (data.isNotEmpty) {
        return data;
      }
    }
    return '';
  }

  // Clear log from cache
  static Future<void> get clearLog async {
    final file = await KingCache.localFile(FilesTypes.log.file);
    if (file.existsSync()) {
      file.writeAsStringSync('');
    }
  }

  // Clear all cache
  static Future<void> get clearAllCache async {
    final path = await getApplicationCacheDirectory();
    if (path.path.isNotEmpty) {
      final dir = Directory(path.path);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    }
  }

  // static share logs file
  static Future<File?> get shareLogs async {
    final file = await KingCache.localFile(FilesTypes.log.file);
    final x = await Share.shareXFiles([XFile(file.path)]);
    if (x.status == ShareResultStatus.success) {
      debugPrint('File Shared Successfully');
    }
    return null;
  }
}
