import 'dart:io';

import '../king_cache.dart';

abstract class ICacheManager {
  Future<File> localFile(String fileName);
  Future<String> get getLogs;
  Future<void> get clearLog;
  Future<void> get clearAllCache;
  Future<File> get getLogFile;
  Future<String?> getCache(String key);
  Future<void> setCache(String key, String data);
  Future<void> removeCache(String key);
  Future<bool> hasCache(String key);
  Future<List<String>> getCacheKeys();
  Future<void> storeLog(String log, {LogLevel level = LogLevel.info});
  Future<void> clearOldLogs({int? maxLogCount = 1000});
}
