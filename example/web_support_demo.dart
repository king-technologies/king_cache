import 'package:king_cache/king_cache.dart';

/// Example demonstrating web support for king_cache
/// This shows how logs are now stored in IndexedDB on web platforms
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
  
  // Get cache keys
  final cacheKeys = await KingCache().getCacheKeys();
  print('\nCache keys: $cacheKeys');
  
  // Check if cache exists
  final hasUserData = await KingCache().hasCache('user_data');
  print('Has user data cache: $hasUserData');
  
  print('\nWeb support demo completed!');
  print('The same API works seamlessly on both web and native platforms.');
}