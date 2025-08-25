// Stub implementation for non-web platforms
import '../king_cache.dart';

abstract class ICacheManagerWeb {
  Future<String> get getLogs;
  Future<void> get clearLog;
  Future<void> get clearAllCache;
  Future<String?> getCache(String table);
  Future<void> setCache(String key, String data);
  Future<void> removeCache(String key);
  Future<bool> hasCache(String key);
  Future<List<String>> getCacheKeys();
  Future<void> storeLog(String log, {LogLevel level = LogLevel.info});
}

class WebCacheManager implements ICacheManagerWeb {
  @override
  Future<String> get getLogs async => '';

  @override
  Future<void> get clearLog async {}

  @override
  Future<void> get clearAllCache async {}

  @override
  Future<String?> getCache(String table) async => null;

  @override
  Future<void> setCache(String key, String data) async {}

  @override
  Future<void> removeCache(String key) async {}

  @override
  Future<bool> hasCache(String key) async => false;

  @override
  Future<List<String>> getCacheKeys() async => [];

  @override
  Future<void> storeLog(String log, {LogLevel level = LogLevel.info}) async {}
}