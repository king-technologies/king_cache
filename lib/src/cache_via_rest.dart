import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../king_cache.dart';

Future<ResponseModel> cacheViaRestExec(
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
  File? file;

  var data = '';
  final fileName = cacheKey ?? url.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  file = await KingCache().localFile('$fileName.json');
  if (file.existsSync()) {
    data = file.readAsStringSync();
    if (data.isNotEmpty) {
      if (isCacheHit != null) {
        isCacheHit(true);
      }
      onSuccess?.call(jsonDecode(data));
    } else {
      isCacheHit?.call(false);
    }
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
    file.deleteSync();
    file = await KingCache().localFile('$fileName.json');
  }
  final res = await KingCache.networkRequest(url,
      formData: formData, method: method, headers: headers);
  if (apiResponse != null) {
    apiResponse(res);
  }
  if (res.status) {
    file.writeAsStringSync(jsonEncode(res.data));
    if (data.isEmpty || jsonDecode(data) != res.data) {
      onSuccess?.call(res.data);
    }
  } else {
    onError?.call(res);
  }
  return res;
}
