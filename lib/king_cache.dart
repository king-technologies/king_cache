library king_cache;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'enums.dart';
import 'global_methods.dart';
import 'response_model.dart';

/// Enum representing different HTTP methods.
///
/// The [HttpMethod] enum provides options for common HTTP methods such as GET, POST, PUT, and DELETE.
enum HttpMethod { get, post, put, delete }

/// A cache management class that provides methods for storing and retrieving cache data.
///
/// The [KingCache] class is designed to store cache data retrieved from a REST API.
/// It provides a method [cacheViaRest] to store cache data via a REST API endpoint.
/// The cache data can be retrieved using by calling the [cacheViaRest] method with the same API endpoint.
/// The class also provides methods to clear the cache and get the log file.
class KingCache {
  factory KingCache() => _instance;

  KingCache._internal();

  static final KingCache _instance = KingCache._internal();

  static String baseUrl = '';

  static void setBaseUrl(String url) {
    baseUrl = url;
  }

  /// Stores cache via REST API.
  ///
  /// This method is used to store cache data retrieved from a REST API.
  /// It takes a [url] parameter as the API endpoint and several optional parameters
  /// for handling success, error, cache hit, API response, HTTP method, form data,
  /// headers, cache update, expiry time, and just API.
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
  /// should be used or update even if it already exists. It is an optional parameter
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
  /// Example:
  /// ```dart
  /// KingCache.cacheViaRest(
  ///  'https://jsonplaceholder.typicode.com/todos/1',
  /// method: HttpMethod.get,
  /// onSuccess: (data) {
  ///  // This will execute 2 times when you have data in data
  /// debugPrint(data);
  /// },
  /// onError: (data) => debugPrint(data.message),
  /// apiResponse: (data) => debugPrint(data.message),
  /// isCacheHit: (isHit) => debugPrint('Is Cache Hit: $isHit'),
  /// shouldUpdate: false,
  /// expiryTime: DateTime.now().add(const Duration(hours: 1)),
  /// );
  static Future<ResponseModel> cacheViaRest(
    String url, {
    void Function(dynamic data)? onSuccess,
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
    String? cacheKey,
  }) async {
    File? file;
    if (baseUrl.isNotEmpty) {
      url = baseUrl + url;
    }
    if (!justApi) {
      final fileName = cacheKey ?? url.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      file = await KingCache.localFile(fileName);
      var data = '';
      if (file != null && file.existsSync()) {
        data = file.readAsStringSync();
        if (data.isNotEmpty) {
          if (isCacheHit != null) {
            isCacheHit(true);
          }

          onSuccess?.call(data);
        } else {
          isCacheHit?.call(false);
        }
      }
      if (data.isNotEmpty && !shouldUpdate) {
        return ResponseModel(
            status: true, message: 'Got data from cache', data: data);
      }
      // Check if the cache has expired
      if (expiryTime != null && DateTime.now().isAfter(expiryTime)) {
        file?.deleteSync();
        file = await KingCache.localFile(fileName);
      }
    }
    final res = await networkRequest(url,
        formData: formData, method: method, headers: headers);
    if (apiResponse != null) {
      apiResponse(res);
    }
    if (res.status) {
      if (!justApi) {
        file?.writeAsStringSync(res.data.toString());
      }
      onSuccess?.call(res.data.toString());
    } else {
      onError?.call(res);
    }
    return res;
  }

  /// Returns a [File] object representing the local file with the given [fileName].
  /// If the file exists in the application cache directory, it is returned.
  /// Otherwise, a new file is created with the given [fileName] in the application cache directory.
  /// If the directory does not exist, it will be created recursively.
  ///
  /// Returns a [Future] that completes with the [File] object.
  ///
  /// Example:
  /// ```dart
  /// File? file = await KingCache.localFile('myFile');
  /// ```
  static Future<File?> localFile(String fileName) async {
    if (kIsWeb) {
      return null;
    }
    final path = applicationDocumentSupport
        ? await getApplicationCacheDirectory()
        : Directory.current;
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
  ///
  /// Example:
  /// ```dart
  /// await KingCache.storeLog('This is a log message');
  /// ```
  static Future<void> storeLog(String log) async {
    final file = await KingCache.localFile(FilesTypes.log.file);
    if (file == null) {
      return;
    }
    log = '${DateTime.now().toIso8601String()}: $log';
    if (file.existsSync()) {
      final data = file.readAsStringSync();
      if (data.isNotEmpty) {
        file.writeAsStringSync('$data\n$log');
      } else {
        file.writeAsStringSync(log);
      }
    }
  }

  /// Retrieves the log data from the local file system.
  /// Returns a Future that completes with a String containing the log data,
  /// or an empty string if the file does not exist or is empty.
  ///
  /// Example:
  /// ```dart
  /// String log = await KingCache.getLogs;
  /// ```
  static Future<String> get getLogs async {
    final file = await KingCache.localFile(FilesTypes.log.file);
    if (file == null) {
      return '';
    }
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
    if (file == null) {
      return;
    }
    if (file.existsSync()) {
      file.writeAsStringSync('');
    }
  }

  /// Clears all the cache stored in the application cache directory.
  ///
  /// This method deletes all the files and directories present in the application cache directory.
  ///
  /// Throws an exception if there is an error while deleting the cache.
  ///
  /// Example:
  /// ```dart
  /// await KingCache.clearAllCache;
  /// ```
  static Future<void> get clearAllCache async {
    if (kIsWeb) {
      return;
    }
    final path = applicationDocumentSupport
        ? await getApplicationCacheDirectory()
        : Directory.current;
    if (path.path.isNotEmpty) {
      final dir = Directory(path.path);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    }
  }

  /// Retrieves the logs file
  /// Returns a Future<File?> representing the shared file.
  /// If the file does not exist, it returns null.
  /// The log file path is determined by the [FilesTypes.log.file] constant.
  /// This method returns a [Future] that resolves to a [File] object representing the log file.
  ///
  /// Example:
  /// ```dart
  /// File? logFile = await getLogFile();
  /// ```
  static Future<File?> get getLogFile async =>
      KingCache.localFile(FilesTypes.log.file);

  /// Retrieves the cached data associated with the given [key].
  /// Returns the cached data as a [String], or null if the data is not found.
  ///
  /// The [key] parameter specifies the unique identifier for the cached data.
  ///
  /// Example usage:
  /// ```dart
  /// String? cachedData = await KingCache.getCacheViaKey('myKey');
  /// if (cachedData != null) {
  ///   // Use the cached data
  /// } else {
  ///   // Data not found in cache
  /// }
  /// ```
  static Future<String?> getCacheViaKey(String key) async {
    final file = await KingCache.localFile(key);
    if (file == null) {
      return null;
    }
    if (file.existsSync()) {
      final data = file.readAsStringSync();
      if (data.isNotEmpty) {
        return data;
      }
    }
    return null;
  }

  /// Sets the cache data for a given key.
  ///
  /// The [key] parameter specifies the unique identifier for the cache data.
  /// The [data] parameter specifies the data to be stored in the cache.
  ///
  /// This method is asynchronous and returns a [Future] that completes when the cache is set.
  /// If the file corresponding to the [key] does not exist, this method does nothing.
  /// If the file exists, it overwrites the existing data with the new [data].
  ///
  /// Example usage:
  /// ```dart
  /// await KingCache.setCacheViaKey('user_data', '{"name": "John", "age": 30}');
  /// ```
  static Future<void> setCacheViaKey(String key, String data) async {
    final file = await KingCache.localFile(key);
    if (file == null) {
      return;
    }
    if (file.existsSync()) {
      file.writeAsStringSync(data);
    }
  }

  /// Removes the cache file associated with the given [key].
  ///
  /// If the cache file does not exist, this method does nothing.
  ///
  /// Example usage:
  /// ```dart
  /// await KingCache.removeCacheViaKey('myKey');
  /// ```
  static Future<void> removeCacheViaKey(String key) async {
    final file = await KingCache.localFile(key);
    if (file == null) {
      return;
    }
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  /// Retrieves a list of cache keys from the application cache directory.
  ///
  /// Returns a [Future] that completes with a [List] of [String] cache keys.
  /// The cache keys represent the names of the files in the application cache directory
  /// that have a '.json' extension.
  ///
  /// Example usage:
  /// ```dart
  /// List<String> cacheKeys = await getCacheKeys();
  /// print(cacheKeys);
  /// ```
  static Future<List<String>> getCacheKeys() async {
    final keys = <String>[];
    if (kIsWeb) {
      return keys;
    }
    final path = applicationDocumentSupport
        ? await getApplicationCacheDirectory()
        : Directory.current;
    if (path.path.isNotEmpty) {
      final dir = Directory(path.path);
      if (dir.existsSync()) {
        final list = dir.listSync();
        for (final file in list) {
          debugPrint(file.path);
          if (file.path.endsWith('.json')) {
            keys.add(file.path.split('/').last);
          }
        }
      }
    }
    return keys;
  }
}
