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

## 0.0.6

* Debug Prints added
* Added `baseUrl` setter to set the base url so you don't ned to pass the base url every time you call the `cacheViaRest` function.

## 0.0.7

* Added `setHeaders` to set the headers so you don't need to pass the headers every time you call the `cacheViaRest` function.
* Test Updated

## 0.0.8

* Added `appendFormData` to append the form data so you don't need to pass the form data every time you call the `cacheViaRest` function.
* Test Updated with more cleanup

## 0.0.9

* Cache File type added to the cache file name so you can easily identify the cache file type.
* Test Updated with more cleanup

## 0.0.10

* Date Format in logs updated to `yyyy-MM-dd HH:mm:ss`
* On Success will not called twice if the cache and api data is same

## 0.0.11

* Added response bodyBytes to the response model so you can get the response body bytes.

## 0.0.12

* Fix Logging and Update Form data 
