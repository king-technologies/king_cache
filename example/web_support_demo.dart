import 'package:flutter/foundation.dart';
import 'package:king_cache/king_cache.dart';

/// Example demonstrating web support for king_cache
/// This shows how logs and network requests are now stored in IndexedDB on web platforms
void main() async {
  debugPrint('King Cache Web Support Demo');
  debugPrint('============================');

  // Store some logs with different levels
  await KingCache().storeLog('Application started');
  await KingCache().storeLog('Debug information', level: LogLevel.debug);
  await KingCache().storeLog('Warning occurred', level: LogLevel.warning);
  await KingCache().storeLog('Error happened', level: LogLevel.error);

  debugPrint('\nLogs stored successfully!');
  debugPrint('On web: Stored in IndexedDB');
  debugPrint('On other platforms: Stored in file system');

  // Retrieve logs
  final logs = await KingCache().getLogs;
  debugPrint('\nRetrieved logs:');
  debugPrint(logs);

  // Cache some data
  await KingCache().setCache('user_data', '{"name": "John", "age": 30}');
  await KingCache()
      .setCache('app_settings', '{"theme": "dark", "language": "en"}');

  debugPrint('\nCache data stored successfully!');

  // Retrieve cache data
  final userData = await KingCache().getCache('user_data');
  final appSettings = await KingCache().getCache('app_settings');

  debugPrint('\nRetrieved cache data:');
  debugPrint('User data: $userData');
  debugPrint('App settings: $appSettings');

  // Demonstrate network caching with cache-first strategy
  debugPrint('\n=== Network Caching Demo ===');

  // Set base URL for API calls
  KingCache.setBaseUrl('https://jsonplaceholder.typicode.com');

  // Make a cached API request
  await KingCache.cacheViaRest(
    '/todos/1',
    onSuccess: (data) {
      debugPrint('API Success: $data');
    },
    isCacheHit: (isHit) {
      debugPrint('Cache hit: $isHit');
      if (isHit) {
        debugPrint('Data served from cache (IndexedDB on web, file on native)');
      } else {
        debugPrint('Data fetched from API and cached');
      }
    },
    onError: (error) {
      debugPrint('API Error: ${error.message}');
    },
    apiResponse: (response) {
      debugPrint('API Response status: ${response.status}');
    },
    expiryTime:
        DateTime.now().add(const Duration(hours: 1)), // Cache for 1 hour
    cacheKey: 'todo_1', // Custom cache key
  );

  debugPrint('\nSecond call to same endpoint (should be cache hit):');

  // Make the same request again - should hit cache
  await KingCache.cacheViaRest(
    '/todos/1',
    onSuccess: (data) {
      debugPrint('API Success: $data');
    },
    isCacheHit: (isHit) {
      debugPrint('Cache hit: $isHit');
    },
    cacheKey: 'todo_1',
  );

  // Get cache keys
  final cacheKeys = await KingCache().getCacheKeys();
  debugPrint('\nCache keys: $cacheKeys');

  // Check if cache exists
  final hasUserData = await KingCache().hasCache('user_data');
  debugPrint('Has user data cache: $hasUserData');

  debugPrint('\nWeb support demo completed!');
  debugPrint('✅ Logging: Works on web (IndexedDB) and native (files)');
  debugPrint('✅ Basic caching: Works on web (IndexedDB) and native (files)');
  debugPrint('✅ Network caching: Works on web (IndexedDB) and native (files)');
  debugPrint('The same API works seamlessly on both web and native platforms.');
}
