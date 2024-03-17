<p align="center">
  <a href="https://github.com/king-technologies/king_cache" title="King Cache">
    <img src="https://raw.githubusercontent.com/king-technologies/developer-utilities/main/images/king_tech.png" width="80px" alt="King Cache"/>
  </a>
</p>

<h1 align="center">🌟 King Cache 🌟</h1>
<p align="center">This package is used to cache API results so the next time you call the same API, it will return the cached result instead of calling the API again. This will help reduce the number of api calls and improve your app's user experience. </p>

<p align="center">This package uses a file-based caching system.</p>

<p align="center">It gives you a couple of functions to manage the cache. It also has a log function so you can add, remove, clear and share logs. It also gives you the ability to set the cache expiry time.</p>



<p align="center">
<a href=" https://pub.dev/packages/king_cache" title="Pub Dev">
<img src="https://img.shields.io/pub/v/king_cache.svg" alt="King Cache"/>
</a>
<a href=" https://pub.dev/packages/king_cache" title="Pub Dev">
<img src="https://img.shields.io/pub/likes/king_cache" alt="King Cache Likes"/></a>
<a href=" https://pub.dev/packages/king_cache" title="Pub Dev">
<img src="https://img.shields.io/pub/points/king_cache" alt="King Cache Points"/></a>
<a href=" https://pub.dev/packages/king_cache" title="Pub Dev">
<img src="https://img.shields.io/pub/popularity/king_cache" alt="King Cache Popularity"/></a>
<a href=" https://pub.dev/packages/king_cache" title="Pub Dev">
<img src="https://img.shields.io/pub/publisher/king_cache" alt="King Cache Publisher"/>
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

[![Pub][pub_badge]][pub]

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

<p align="center">Made with Flutter & ❤️ in India</p>
