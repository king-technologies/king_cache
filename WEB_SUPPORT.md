# Web Support for King Cache

This document explains the web support features added to the King Cache package.

## Overview

King Cache now supports storing logs and cache data in IndexedDB when running on web platforms, while maintaining full compatibility with existing file-based storage on mobile and desktop platforms.

## Features

### Log Storage
- **Web**: Logs are stored in IndexedDB using the `logs` object store
- **Other platforms**: Logs continue to be stored in the file system as before
- **Consistent formatting**: Both platforms use the same log format: `YYYY-MM-DD HH:MM:SS [LEVEL]: message`

### Cache Storage
- **Web**: Cache data is stored in IndexedDB using the `cache` object store
- **Other platforms**: Cache data continues to be stored as files in the cache directory
- **Same API**: All cache methods work identically across platforms

### Network Caching
- **Web**: API responses are cached in IndexedDB using the `cache` object store
- **Other platforms**: API responses are cached as JSON files in the cache directory
- **Cache-first strategy**: Checks cache first before making network requests
- **Automatic cache management**: Handles cache expiry and updates

## API Compatibility

The public API remains unchanged. All existing code will work without modifications:

```dart
// This works on both web and native platforms
await KingCache().storeLog('Application started');
final logs = await KingCache().getLogs;
await KingCache().setCache('key', 'value');
final value = await KingCache().getCache('key');

// Network caching also works seamlessly on web
await KingCache.cacheViaRest(
  '/api/users',
  onSuccess: (data) => print('Data: $data'),
  isCacheHit: (isHit) => print('Cache hit: $isHit'),
  shouldUpdate: false,
  expiryTime: DateTime.now().add(Duration(hours: 1)),
);
```

## Implementation Details

### WebCacheManager
- Manages IndexedDB operations for web platforms
- Uses two object stores: `logs` and `cache`
- Automatically initializes the database and creates object stores if needed

### Conditional Loading
- Web-specific code is only loaded on web platforms
- Non-web platforms use a stub implementation
- No impact on bundle size for mobile/desktop applications

## Storage Persistence

On web platforms, the implementation includes support for persistent storage:

```dart
final webManager = WebCacheManager();
final isPersistent = await webManager.makeStoragePersist();
```

This requests the browser to make the IndexedDB storage persistent, preventing data loss when storage space is low.

## Browser Compatibility

The web implementation uses:
- IndexedDB for storage
- JS interop for browser API access
- Compatible with all modern browsers that support IndexedDB

## Migration

No migration is needed for existing applications. When upgrading:
1. Web applications will automatically start using IndexedDB
2. Mobile/desktop applications continue using file storage
3. All existing logs and cache data remain accessible

## Example Usage

See `example/web_support_demo.dart` for a complete example demonstrating the web support features.