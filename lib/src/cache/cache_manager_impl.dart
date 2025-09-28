// Conditional export to pick the platform-specific CacheManagerImpl.
// On web, export the web implementation; otherwise export the IO implementation.
export 'cache_manager_io.dart' if (dart.library.html) 'cache_manager_web.dart';
