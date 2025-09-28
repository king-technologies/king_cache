part of '../../king_cache.dart';

class CacheService {
  CacheService._internal();

  static final CacheManager _manager = CacheManagerImpl();

  static Future<void> storeLog(String log, {LogLevel level = LogLevel.info}) =>
      _manager.storeLog(log, level: level);

  static Future<String> get getLogs => _manager.getLogs;

  static Future<void> get clearLogs => _manager.clearLog;

  static Future<void> setCache(String key, String data) =>
      _manager.setCache(key, data);

  static Future<String?> getCache(String key) => _manager.getCache(key);

  static Future<void> removeCache(String key) => _manager.removeCache(key);

  static Future<bool> hasCache(String key) => _manager.hasCache(key);

  static Future<List<String>> get getCacheKeys => _manager.getCacheKeys;

  static Future<void> get clearAllCache => _manager.clearAllCache;

  static Future<void> clearOldLogs({int maxLogCount = 1000}) =>
      _manager.clearOldLogs(maxLogCount: maxLogCount);
}
