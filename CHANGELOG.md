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

## 0.0.4

* Added `justApi` parameter to `cacheViaRest` function to get the api response without caching it. for example, if you just want to get the api response and don't want to cache it, you can set `justApi` to `true` and it will return the api response without caching it.

## 0.0.5

* Removed share logs as file as this is not a default functionality and adding package increases the package size. If you want to share logs, you can use the `getLogFile` function to get the log file and share it however .

* Added `cacheKey` parameter to `cacheViaRest` function to set the cache key. for example, if you want to cache the api response with a specific key, you can set `cacheKey` to `your_key` and it will cache the api response with the key `your_key`.
  
* Added`getCacheViaKey` function to get the cache with a specific key. for example, if you want to get the cache with a specific key, you can set `cacheKey` to `your_key` and it will return the cache with the key `your_key`.
  
* Added `setCacheViaKey` function to set the cache with a specific key. for example, if you want to set the cache with a specific key, you can set `cacheKey` to `your_key` and it will set the cache with the key `your_key`.
  
* Added `getCacheKeys` function to get all the cache keys.
  
* Added `removeCacheViaKey` function to remove the cache with a specific key. for example, if you want to remove the cache with a specific key, you can set `cacheKey` to `your_key` and it will remove the cache with the key `your_key`.