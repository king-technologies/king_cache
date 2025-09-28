part of '../../king_cache.dart';

class CacheViaRestService {
  factory CacheViaRestService() => _instance;
  CacheViaRestService._internal();
  static final CacheViaRestService _instance = CacheViaRestService._internal();

  static Future<ResponseModel> call(
    String url, {
    void Function(dynamic data)? onSuccess,
    void Function(bool isHit)? isCacheHit,
    void Function(ResponseModel data)? onError,
    void Function(ResponseModel data)? apiResponse,
    HttpMethod method = HttpMethod.get,
    Map<String, dynamic>? formData,
    Map<String, String> headers = const {},
    bool shouldUpdate = false,
    DateTime? expiryTime,
    String? cacheKey,
  }) async {
    final fileName = cacheKey ?? url.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final cacheKeyWithExt = '$fileName.json';

    var data = await CacheService.getCache(cacheKeyWithExt);

    // Cache Hit
    if (data != null && data.isNotEmpty) {
      isCacheHit?.call(true);
      onSuccess?.call(jsonDecode(data));

      if (!shouldUpdate) {
        return ResponseModel(
          headers: {},
          status: true,
          message: 'Got data from cache',
          data: jsonDecode(data),
          bodyBytes: Uint8List(0),
        );
      }
    } else {
      isCacheHit?.call(false);
    }

    // Cache Expiry
    if (expiryTime != null && DateTime.now().isAfter(expiryTime)) {
      await CacheService.removeCache(cacheKeyWithExt);
      data = null;
    }

    // Fetch from network
    final res = await NetworkService.call(
      url,
      formData: formData,
      method: method,
      headers: headers,
    );

    apiResponse?.call(res);

    if (res.status) {
      await CacheService.setCache(cacheKeyWithExt, jsonEncode(res.data));

      if (data == null || jsonDecode(data) != res.data) {
        onSuccess?.call(res.data);
      }
    } else {
      onError?.call(res);
    }

    return res;
  }
}
