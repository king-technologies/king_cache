<p align="center">
  <a href="https://github.com/king-technologies/king_cache" title="King Cache">
    <img src="https://raw.githubusercontent.com/king-technologies/developer-utilities/main/images/king_tech.png" width="80px" alt="King Cache"/>
  </a>
</p>

<h1 align="center">🌟 King Cache 🌟</h1>
<p align="center">This package is used to cache API results so the next time you call the same API, it will return the cached result instead of calling the API again. This will help reduce the number of api calls and improve your app's user experience. </p>

<p align="center">This package uses a file-based caching system on mobile/desktop and IndexedDB on web platforms.</p>

<p align="center">It gives you a couple of functions to manage the cache. It also has a log function so you can add, remove, clear and share logs. It also gives you the ability to set the cache expiry time.</p>


<p align="center">
<a href="https://pub.dev/packages/king_cache"title="PubDev">
<img src="https://img.shields.io/pub/v/king_cache.svg?label=Pub&logo=Dart&style=flat-square" alt="King Cache"/></a>
<a href="https://pub.dev/packages/king_cache" title="Pub Dev">
<img src="https://img.shields.io/pub/likes/king_cache?label=Likes&logo=Dart&style=flat-square" alt="King Cache Likes"/></a>
<a href="https://pub.dev/packages/king_cache" title="Pub Dev">
<img src="https://img.shields.io/pub/points/king_cache?label=Points&logo=Dart&style=flat-square" alt="King Cache Points"/></a>
<a href="https://pub.dev/packages/king_cache" title="Pub Dev">
<img src="https://img.shields.io/pub/popularity/king_cache?label=Popularity&logo=Dart&style=flat-square" alt="King Cache Popularity"/></a>
<a href="https://pub.dev/packages/king_cache" title="Pub Dev">
<img src="https://img.shields.io/pub/publisher/king_cache?label=Publisher&logo=Dart&style=flat-square" alt="King Cache Publisher"/>
</a>
</p>

<p align="center">
<a href="https://github.com/king-technologies/king_cache/blob/master/LICENSE" title="License">
<img src="https://img.shields.io/github/license/king-technologies/king_cache?label=License&logo=Github&style=flat-square" alt="King Cache License"/>
</a>
<a href="https://github.com/king-technologies/king_cache/fork" title="Forks">
<img src="https://img.shields.io/github/forks/king-technologies/king_cache?label=Forks&logo=Github&style=flat-square" alt="King Cache Forks"/>
</a>
<a href="https://github.com/king-technologies/king_cache/stargazers" title="Stars">
<img src="https://img.shields.io/github/stars/king-technologies/king_cache?label=Stars&logo=Github&style=flat-square" alt="King Cache Stars"/>
</a>
<a href="https://github.com/king-technologies/king_cache/issues" title="Issues">
<img src="https://img.shields.io/github/issues/king-technologies/king_cache?label=Issues&logo=Github&style=flat-square" alt="King Cache Issues"/>
</a>
<a href="https://github.com/king-technologies/king_cache/pulls" title="Pull Requests">
<img src="https://img.shields.io/github/issues-pr/king-technologies/king_cache?label=Pull%20Requests&logo=Github&style=flat-square" alt="King Cache Pull Requests"/>
</a>
<a href="https://github.com/king-technologies/king_cache" title="Repo Size">
<img src="https://img.shields.io/github/repo-size/king-technologies/king_cache?label=Repo%20Size&logo=Github&style=flat-square" alt="King Cache Repo Size"/>
</a>
<a href="https://discord.gg/CJU4UNTaFt" title="Join Community">
<img src="https://img.shields.io/discord/737854816402800690?color=%236d82cb&label=Join%20Community&logo=discord&logoColor=%23FFFFFF&style=flat-square" alt="Join discord"/>
</a>

## Features

![Screenshot 1](https://raw.githubusercontent.com/king-technologies/king_cache/main/screenshots/screenshot_1.png)
1. Cache API results.
2. Set cache expiry time.
3. Manage cache.
4. Log cache.
5. Clear cache.
6. Share cache.
7. **Web Support** - Full IndexedDB support for web platforms.
8. **Markdown Caching** - Specialized caching for markdown content and tech books.

## Getting started

1. Add this package to your pubspec.yaml file.
2. Import the package.
3. Call the functions.

## Usage

### Basic API Caching

```dart
import 'package:king_cache/king_cache.dart';

// Cache API responses
await KingCache.cacheViaRest(
  'https://api.example.com/data',
  onSuccess: (data) => print('Data: $data'),
  isCacheHit: (isHit) => print('Cache hit: $isHit'),
  shouldUpdate: false,
  expiryTime: DateTime.now().add(Duration(hours: 1)),
);
```

### Markdown Content Caching

King Cache now supports specialized caching for markdown content, perfect for tech books, documentation, and educational content:

```dart
// Cache markdown content
await KingCache().cacheMarkdown(
  'chapter-1',
  '''# Chapter 1: Introduction

This is the first chapter of our guide.

## Section 1.1: Getting Started

Welcome to the tutorial!
''',
  expiryDate: DateTime.now().add(Duration(days: 7)),
);

// Retrieve markdown content
final content = await KingCache().getMarkdownContent('chapter-1');
if (content != null && !content.isExpired) {
  print('Title: ${content.title}');
  print('Headers: ${content.headers}');
  print('Content: ${content.content}');
}
```
### Cache Management

```dart
// Check if content exists
final exists = await KingCache().hasMarkdownContent('chapter-1');

// Get all markdown cache keys
final keys = await KingCache().getMarkdownKeys();

// Remove specific content
await KingCache().removeMarkdownContent('chapter-1');

// Clear all markdown cache
await KingCache().clearAllMarkdownCache();
```

### Traditional Cache Operations

```dart
// Basic cache operations
await KingCache().setCache('key', 'value');
final value = await KingCache().getCache('key');
await KingCache().removeCache('key');
final exists = await KingCache().hasCache('key');

// Log operations
await KingCache().storeLog('Application started');
final logs = await KingCache().getLogs;
await KingCache().clearLog;
```

## Original Usage Examples

For backward compatibility, here are the traditional API caching examples:

```dart
KingCache.setBaseUrl('https://jsonplaceholder.typicode.com/');
```
```dart
KingCache.setHeaders({'Content-Type': 'application/json'});
```

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
## 🧑🏻 Author

**Rohit Jain**

- 🌌 [Profile](https://github.com/Rohit19060 "Rohit Jain")

- 🏮 [Email](mailto:rohitjain19060@gmail.com?subject=Hi%20from%20King%20Cache "Hi!")

- 🦁 [Website](https://kingtechnologies.dev "Welcome")

<h2 align="center">🤝 Support</h2>
<h3 align="center">You can expect responsive replies and fast fixes to any issues that appear.</h3>

<p align="center">🎀 Contributions (<a href="https://guides.github.com/introduction/flow" title="GitHub flow">GitHub Flow</a>), 🔥 issues, and 🥮 feature requests are most welcome!</p>

<p align="center">💙 If you like this project, Give it a ⭐ and Share it with friends!</p>
<p align="center">💰 Donations Links</p>
<p align="center">
<a href="https://www.paypal.me/kingrohitJ" title="PayPal"><img src="https://raw.githubusercontent.com/king-technologies/developer-utilities/main/images/paypal.png" alt="PayPal"/></a>
<a href="https://www.buymeacoffee.com/rohitjain" title="Buy me a Coffee"><img src="https://raw.githubusercontent.com/king-technologies/developer-utilities/main/images/coffee.png" alt="Buy me a Coffee"/></a>
<a href="https://ko-fi.com/rohitjain" title="Ko-fi"><img src="https://raw.githubusercontent.com/king-technologies/developer-utilities/main/images/kofi.png" alt="Ko-fi"/></a>
<a href="https://www.patreon.com/KingTechnologies" title="Patreon"><img src="https://raw.githubusercontent.com/king-technologies/developer-utilities/main/images/patreon.png" alt="Patreon"/></a>
</p>

## Web Support

King Cache now supports web platforms with IndexedDB storage! The same API works seamlessly across all platforms:

- **Mobile/Desktop**: File-based storage
- **Web**: IndexedDB storage
- **API**: Identical across all platforms

See [WEB_SUPPORT.md](WEB_SUPPORT.md) for detailed information about web support features.

## Markdown Caching

King Cache includes specialized support for markdown content and tech book organization:

- **Markdown Content**: Cache markdown with automatic title/header extraction
- **Tech Books**: Organize content by books, chapters, and sections
- **Expiry Management**: Automatic content expiration
- **Platform Support**: Works on all platforms (mobile, desktop, web)

See [MARKDOWN_CACHING.md](MARKDOWN_CACHING.md) for detailed documentation and examples.

<p align="center">Made with Flutter & ❤️ in India</p>
