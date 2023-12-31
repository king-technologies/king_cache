class ResponseModel {
  const ResponseModel(
      {required this.status,
      required this.message,
      this.data,
      this.statusCode = 200});

  final bool status;
  final int statusCode;
  final String message;
  final dynamic data;

  @override
  String toString() =>
      'ResponseModel{status: $status, message: $message, data: $data, statusCode: $statusCode}';
}
