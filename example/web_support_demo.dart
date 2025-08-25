import 'package:king_cache/king_cache.dart';

/// Example demonstrating web support for king_cache
/// This shows how logs and network requests are now stored in IndexedDB on web platforms
void main() async {
  print('King Cache Web Support Demo');
  print('============================');
  
  // Store some logs with different levels
  await KingCache().storeLog('Application started', level: LogLevel.info);
  await KingCache().storeLog('Debug information', level: LogLevel.debug);
  await KingCache().storeLog('Warning occurred', level: LogLevel.warning);
  await KingCache().storeLog('Error happened', level: LogLevel.error);
  
  print('\nLogs stored successfully!');
  print('On web: Stored in IndexedDB');
  print('On other platforms: Stored in file system');
  
  // Retrieve logs
  final logs = await KingCache().getLogs;
  print('\nRetrieved logs:');
  print(logs);
  
  // Cache some data
  await KingCache().setCache('user_data', '{"name": "John", "age": 30}');
  await KingCache().setCache('app_settings', '{"theme": "dark", "language": "en"}');
  
  print('\nCache data stored successfully!');
  
  // Retrieve cache data
  final userData = await KingCache().getCache('user_data');
  final appSettings = await KingCache().getCache('app_settings');
  
  print('\nRetrieved cache data:');
  print('User data: $userData');
  print('App settings: $appSettings');
  
  // Demonstrate network caching with cache-first strategy
  print('\n=== Network Caching Demo ===');
  
  // Set base URL for API calls
  KingCache.setBaseUrl('https://jsonplaceholder.typicode.com');
  
  // Make a cached API request
  await KingCache.cacheViaRest(
    '/todos/1',
    onSuccess: (data) {
      print('API Success: $data');
    },
    isCacheHit: (isHit) {
      print('Cache hit: $isHit');
      if (isHit) {
        print('Data served from cache (IndexedDB on web, file on native)');
      } else {
        print('Data fetched from API and cached');
      }
    },
    onError: (error) {
      print('API Error: ${error.message}');
    },
    apiResponse: (response) {
      print('API Response status: ${response.status}');
    },
    shouldUpdate: false, // Don't update if cache exists
    expiryTime: DateTime.now().add(Duration(hours: 1)), // Cache for 1 hour
    cacheKey: 'todo_1', // Custom cache key
  );
  
  print('\nSecond call to same endpoint (should be cache hit):');
  
  // Make the same request again - should hit cache
  await KingCache.cacheViaRest(
    '/todos/1',
    onSuccess: (data) {
      print('API Success: $data');
    },
    isCacheHit: (isHit) {
      print('Cache hit: $isHit');
    },
    cacheKey: 'todo_1',
  );
  
  // Get cache keys
  final cacheKeys = await KingCache().getCacheKeys();
  print('\nCache keys: $cacheKeys');
  
  // Check if cache exists
  final hasUserData = await KingCache().hasCache('user_data');
  print('Has user data cache: $hasUserData');
  
  print('\nWeb support demo completed!');
  print('✅ Logging: Works on web (IndexedDB) and native (files)');
  print('✅ Basic caching: Works on web (IndexedDB) and native (files)');
  print('✅ Network caching: Works on web (IndexedDB) and native (files)');
  print('The same API works seamlessly on both web and native platforms.');
}