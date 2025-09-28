import '../../king_cache.dart' show LogLevel;

abstract class CacheManager {
  Future<String> get getLogs;
  Future<void> get clearLog;
  Future<void> get clearAllCache;

  Future<String?> getCache(String key);
  Future<void> setCache(String key, String data);
  Future<void> removeCache(String key);
  Future<bool> hasCache(String key);
  Future<List<String>> get getCacheKeys;

  Future<void> storeLog(String log, {LogLevel level = LogLevel.info});
  Future<void> clearOldLogs({int maxLogCount = 1000});
}
