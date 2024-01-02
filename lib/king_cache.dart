library king_cache;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'enums.dart';
import 'network_request.dart';
import 'response_model.dart';

/// A cache management class that provides methods for storing and retrieving cache data.
///
/// The [KingCache] class is designed to store cache data retrieved from a REST API.
/// It provides a method [cacheViaRest] to store cache data via a REST API endpoint.
/// The cache data can be retrieved using the [getLog] method.
/// The class also provides methods to clear the cache and share the log file.
class KingCache {
  factory KingCache() => _instance;

  KingCache._internal();

  static final KingCache _instance = KingCache._internal();

  /// Stores cache via REST API.
  ///
  /// This method is used to store cache data retrieved from a REST API.
  /// It takes a [url] parameter as the API endpoint and several optional parameters
  /// for handling success, error, cache hit, API response, HTTP method, form data,
  /// headers, cache update, and expiry time.
  ///
  /// The [onSuccess] callback is called when the cache data is successfully retrieved
  /// and stored. It takes a single parameter [data] which represents the retrieved data.
  ///
  /// The [isCacheHit] callback is called with a boolean parameter [isHit] indicating
  /// whether the cache was hit or not. It is an optional parameter and can be null.
  ///
  /// The [onError] callback is called when there is an error in the API response.
  /// It takes a single parameter [data] of type [ResponseModel] which represents
  /// the error response.
  ///
  /// The [apiResponse] callback is called with the [ResponseModel] object representing
  /// the API response. It is an optional parameter and can be null.
  ///
  /// The [method] parameter specifies the HTTP method to be used for the API request.
  /// It is an optional parameter and its default value is [HttpMethod.get].
  ///
  /// The [formData] parameter is a map of key-value pairs representing the form data
  /// to be sent in the API request. It is an optional parameter and can be null.
  ///
  /// The [headers] parameter is a map of key-value pairs representing the headers
  /// to be sent in the API request. It is an optional parameter and its default value
  /// is {'Content-Type': 'application/json', 'Accept': 'application/json'}.
  ///
  /// The [shouldUpdate] parameter is a boolean flag indicating whether the cache
  /// should be updated even if it already exists. It is an optional parameter
  /// and its default value is false.
  ///
  /// The [expiryTime] parameter is a DateTime object representing the expiry time
  /// of the cache. If the cache has expired, it will be deleted and a new cache
  /// will be created. It is an optional parameter and can be null.
  ///
  /// The [justApi] parameter is a boolean flag indicating whether the cache
  /// should be used or updated even if it already exists. It is an optional parameter
  /// and its default value is false.
  ///
  /// Returns a [Future] of [ResponseModel] representing the API response.
  /// If the cache data is retrieved successfully, the [status] property of the
  /// [ResponseModel] will be true and the [data] property will contain the retrieved data.
  /// If there is an error in the API response, the [status] property will be false
  /// and the [data] property will contain the error response.
  /// If the cache data is retrieved successfully and the [shouldUpdate] flag is false,
  /// the [status] property will be true and the [message] property will be 'Got data from cache'.
  /// If the cache has expired, it will be deleted and a new cache will be created.
  ///
  static Future<ResponseModel> cacheViaRest(
    String url, {
    required void Function(dynamic data) onSuccess,
    void Function(bool isHit)? isCacheHit,
    void Function(ResponseModel data)? onError,
    void Function(ResponseModel data)? apiResponse,
    HttpMethod method = HttpMethod.get,
    Map<String, dynamic>? formData,
    Map<String, String> headers = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    },
    bool shouldUpdate = false,
    DateTime? expiryTime,
    bool justApi = false,
  }) async {
    File? file;
    if (justApi) {
      final fileName = url.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      file = await KingCache.localFile(fileName);
      var gotData = false;
      if (file.existsSync()) {
        final data = file.readAsStringSync();
        if (data.isNotEmpty) {
          if (isCacheHit != null) {
            isCacheHit(true);
          }
          gotData = true;
          onSuccess(data);
        } else {
          if (isCacheHit != null) {
            isCacheHit(false);
          }
        }
      }
      if (gotData && !shouldUpdate) {
        return const ResponseModel(
            status: true, message: 'Got data from cache');
      }
      // Check if the cache has expired
      if (expiryTime != null && DateTime.now().isAfter(expiryTime)) {
        file.deleteSync();
        file = await KingCache.localFile(fileName);
      }
    }

    final res = await networkRequest(url,
        formData: formData, method: method, headers: headers);
    if (apiResponse != null) {
      apiResponse(res);
    }
    if (res.status) {
      if (justApi && file != null) {
        file.writeAsStringSync(res.data.toString());
      }
      onSuccess(res.data);
    } else if (onError != null) {
      onError(res);
    }
    return res;
  }

  /// Returns a [File] object representing the local file with the given [fileName].
  /// If the file exists in the application cache directory, it is returned.
  /// Otherwise, a new file is created with the given [fileName] in the application cache directory.
  /// If the directory does not exist, it will be created recursively.
  ///
  /// Returns a [Future] that completes with the [File] object.
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

  /// Stores the given log message in a file.
  ///
  /// The [log] parameter represents the log message to be stored.
  /// This method appends the log message to an existing log file or creates a new file if it doesn't exist.
  /// If the file already exists, the log message is appended to the existing content.
  /// If the file doesn't exist, a new file is created with the log message as its content.
  ///
  /// Throws an exception if there is an error while reading or writing the file.
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

  /// Retrieves the log data from the local file system.
  /// Returns a Future that completes with a String containing the log data,
  /// or an empty string if the file does not exist or is empty.
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

  /// Clears the log file in the KingCache library.
  ///
  /// This method deletes the contents of the log file, if it exists.
  /// It is an asynchronous operation and returns a [Future] that completes when the log file is cleared.
  /// The log file path is determined by the [FilesTypes.log.file] constant.
  ///
  /// Example usage:
  /// ```dart
  /// await KingCache.clearLog;
  /// ```
  static Future<void> get clearLog async {
    final file = await KingCache.localFile(FilesTypes.log.file);
    if (file.existsSync()) {
      file.writeAsStringSync('');
    }
  }

  /// Clears all the cache stored in the application cache directory.
  ///
  /// This method deletes all the files and directories present in the application cache directory.
  ///
  /// Throws an exception if there is an error while deleting the cache.
  static Future<void> get clearAllCache async {
    final path = await getApplicationCacheDirectory();
    if (path.path.isNotEmpty) {
      final dir = Directory(path.path);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    }
  }

  /// Retrieves the logs file and shares it using the ShareXFiles plugin.
  /// Returns a Future<File> representing the shared file.
  /// If the sharing is successful, it prints a debug message.
  static Future<File?> get shareLogs async {
    final file = await KingCache.localFile(FilesTypes.log.file);
    final x = await Share.shareXFiles([XFile(file.path)]);
    if (x.status == ShareResultStatus.success) {
      debugPrint('File Shared Successfully');
    }
    return null;
  }
}
