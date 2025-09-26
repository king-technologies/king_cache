import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../king_cache.dart';
import 'web_methods.dart';

Future<ResponseModel> cacheViaRestExecWeb(
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
  final storage = WebCacheManager();
  var data = '';
  final fileName = cacheKey ?? url.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

  // Check if cache exists
  final cachedData = await storage.getCache('$fileName.json');
  if (cachedData != null && cachedData.isNotEmpty) {
    data = cachedData;
    if (isCacheHit != null) {
      isCacheHit(true);
    }
    onSuccess?.call(jsonDecode(data));
  } else {
    isCacheHit?.call(false);
  }

  if (data.isNotEmpty && !shouldUpdate) {
    return ResponseModel(
        headers: {},
        status: true,
        message: 'Got data from cache',
        data: data,
        bodyBytes: Uint8List(0));
  }

  // Check if the cache has expired
  if (expiryTime != null && DateTime.now().isAfter(expiryTime)) {
    await storage.removeCache('$fileName.json');
  }

  final res = await KingCache.networkRequest(url,
      formData: formData, method: method, headers: headers);
  if (apiResponse != null) {
    apiResponse(res);
  }
  if (res.status) {
    await storage.setCache('$fileName.json', jsonEncode(res.data));
    if (data.isEmpty || jsonDecode(data) != res.data) {
      onSuccess?.call(res.data);
    }
  } else {
    onError?.call(res);
  }
  return res;
}
