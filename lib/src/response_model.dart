part of '../king_cache.dart';

class ResponseModel {
  const ResponseModel({
    required this.status,
    required this.message,
    required this.bodyBytes,
    this.data,
    this.statusCode = 200,
  });

  final bool status;
  final int statusCode;
  final String message;
  final dynamic data;
  final Uint8List bodyBytes;

  @override
  String toString() =>
      'Response: {status: $status, message: $message, data: $data, statusCode: $statusCode}';
}
