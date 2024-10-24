part of '../king_cache.dart';

class ResponseModel {
  const ResponseModel({
    required this.status,
    required this.message,
    this.bodyBytes,
    this.data,
    this.statusCode = 200,
    this.headers = const {},
  });

  final bool status;
  final int statusCode;
  final String message;
  final dynamic data;
  final Uint8List? bodyBytes;
  final Map<String, String> headers;

  @override
  String toString() => 'Response: {status: $status, message: $message, data: $data, statusCode: $statusCode, headers: $headers}';
}
