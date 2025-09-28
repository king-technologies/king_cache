import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../king_cache.dart'
    show applicationDocumentSupport, LogLevel, FilesTypes, localFile;
import 'cache_manager.dart' show CacheManager;

/// File-based implementation of [CacheManager] for non-Web platforms.
/// Uses JSON files stored in the app support directory.
class CacheManagerImpl implements CacheManager {
  CacheManagerImpl();

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
  @override
  Future<String?> getCache(String key) async {
    final file = await localFile(key);
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
  @override
  Future<void> setCache(String key, String data) async {
    final file = await localFile(key);
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
  @override
  Future<void> removeCache(String key) async {
    final file = await localFile(key);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  /// Checks if the cache file associated with the given [key] exists.
  /// Returns a [Future] that completes with a boolean value indicating whether the cache file exists.
  /// If the cache file exists, the [Future] completes with true, otherwise it completes with false.
  ///
  /// Example usage:
  /// ```dart
  /// bool cacheExists = await KingCache.hasCache('myKey');
  /// ```
  @override
  Future<bool> hasCache(String key) async {
    final file = await localFile(key);
    if (file.existsSync()) {
      return true;
    }
    return false;
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
  @override
  Future<List<String>> get getCacheKeys async {
    final keys = <String>[];
    final path = applicationDocumentSupport
        ? await getApplicationCacheDirectory()
        : Directory('${Directory.current.path}/cache');
    if (path.path.isNotEmpty) {
      final dir = Directory(path.path);
      if (dir.existsSync()) {
        final list = dir.listSync();
        for (final file in list) {
          if (file.path.endsWith('.json')) {
            keys.add(file.path.split('/').last);
          }
        }
      }
    }
    return keys;
  }

  @override
  Future<void> clearOldLogs({int? maxLogCount = 1000}) async {
    final file = await localFile(FilesTypes.log.file);
    if (file.existsSync()) {
      file.writeAsStringSync(file
          .readAsStringSync()
          .split('\n')
          .take(maxLogCount ?? 1000)
          .join('\n'));
    }
  }

  @override
  Future<String> get getLogs async {
    final file = await localFile(FilesTypes.log.file);
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
  @override
  Future<void> get clearLog async {
    final file = await localFile(FilesTypes.log.file);
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
  @override
  Future<void> get clearAllCache async {
    final path = applicationDocumentSupport
        ? await getApplicationCacheDirectory()
        : Directory('${Directory.current.path}/cache');
    if (path.path.isNotEmpty) {
      if (path.existsSync()) {
        path.deleteSync(recursive: true);
      }
    }
  }

  @override
  Future<void> storeLog(String log, {LogLevel level = LogLevel.info}) async {
    final file = await localFile(FilesTypes.log.file);
    final date = DateTime.now().toLocal();
    final datePart = date.toString().split(' ')[0];
    final timePart =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
    final logLevel = level.toString().split('.').last.toUpperCase();
    log = '$datePart $timePart [$logLevel]: $log';
    if (file.existsSync()) {
      final data = file.readAsStringSync();
      if (data.isNotEmpty) {
        file.writeAsStringSync('$data\n$log');
      } else {
        file.writeAsStringSync(log);
      }
    }
  }
}
