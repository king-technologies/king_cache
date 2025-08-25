import 'dart:typed_data';

import '../king_cache.dart';

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
  // This is a stub implementation for non-web platforms
  // The actual implementation should use the file-based cacheViaRestExec
  throw UnsupportedError(
      'cacheViaRestExecWeb is only supported on web platforms');
}