# King Cache

This package is used to cache API results so the next time you call the same API, it will return the cached result instead of calling the API again. This will help reduce the number of api calls and improve your app's user experience.

This package uses a file-based caching system.

It gives you a couple of functions to manage the cache.
It also has a log function so you can add, remove, clear and share logs.
It also gives you the ability to set the cache expiry time.

## Features

![Screenshot 1](https://raw.githubusercontent.com/king-technologies/king_cache/main/screenshots/screenshot_1.png)
1. Cache API results.
2. Set cache expiry time.
3. Manage cache.
4. Log cache.
5. Clear cache.
6. Share cache.

## Getting started

1. Add this package to your pubspec.yaml file.
2. Import the package.
3. Call the functions.

## Usage

```dart
TextButton(
    onPressed: () async {
    KingCache.storeLog('Call Json Place Holder API');
    await KingCache.cacheViaRest(
        'https://jsonplaceholder.typicode.com/todos/1',
        method: HttpMethod.get,
        onSuccess: (data) {
        // This will execute 2 times when you have data in data
        debugPrint(data);
        KingCache.storeLog('Response: $data');
        },
        onError: (data) => debugPrint(data.message),
        apiResponse: (data) => debugPrint(data.message),
        isCacheHit: (isHit) => debugPrint('Is Cache Hit: $isHit'),
        shouldUpdate: false,
        expiryTime: DateTime.now().add(const Duration(hours: 1)),
    );
    KingCache.storeLog('Call Json Place Holder API');
    },
    child: const Text('Json Place Holder API'),
),
```
```dart
TextButton(
    onPressed: () async {
    debugPrint(await KingCache.getLog);
    },
    child: const Text('Get Logs'),
)
```
```dart
TextButton(
    onPressed: () => KingCache.shareLogs,
    child: const Text('Share Logs'),
)
```
```dart
TextButton(
    onPressed: () => KingCache.clearLog,
    child: const Text('Clear Logs'),
)
```
```dart
TextButton(
    onPressed: () => KingCache.clearAllCache,
    child: const Text('Clear All Cache'),
)
```

## Additional information

If you have any questions or suggestions, please feel free to contact us at [King Technologies](https://kingtechnologies.dev/).

Please file [GitHub Issues](https://github.com/king-technologies/king_cache/issues)
for bugs and feature requests.

You can expect responsive replies and fast fixes to any issues that appear.

## License

MIT License

## Next Steps

- [ ] Data Encryption and Decryption.
- [ ] Add more tests.
- [ ] More Use Cases.
- [ ] Debug Logs