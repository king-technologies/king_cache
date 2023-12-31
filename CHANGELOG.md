## 0.0.1

* Initial release
* Created this package to cache apis results so next time when you call the same api, it will return the cached result instead of calling the api again. This will help to reduce the number of api calls and improve the user experience of your app.
* This package uses file based caching system.
* It give you couple of functions to manage the cache.
* I also added a log function so you can add, remove, clear and share logs.
* It also give you ability to set the cache expiry time.

## 0.0.2

* Examples updated

## 0.0.3

* Rename the function `storeCacheViaRest` to `cacheViaRest`
* New cache callbacks added to get the cache hit and miss.
* New API response callback added to get the api response and error.