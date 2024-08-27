part of '../king_cache.dart';

Future<ResponseModel> networkRequestExec({
  required String url,
  required HttpMethod method,
  required Map<String, dynamic> formData,
  required Map<String, String> headers,
}) async {
  try {
    Response response;
    switch (method) {
      case HttpMethod.get:
        response = await get(Uri.parse(url), headers: headers);
        break;
      case HttpMethod.post:
        response = await post(Uri.parse(url),
            body: jsonEncode(formData), headers: headers);
        break;
      case HttpMethod.put:
        response = await put(Uri.parse(url),
            body: jsonEncode(formData), headers: headers);
        break;
      case HttpMethod.delete:
        response = await delete(Uri.parse(url), headers: headers);
        break;
      case HttpMethod.patch:
        response = await patch(Uri.parse(url),
            body: jsonEncode(formData), headers: headers);
        break;
    }
    final responseHeaders = response.headers;
    final res = response.body.isNotEmpty
        ? jsonDecode(const Utf8Decoder().convert(response.bodyBytes))
        : {'message': 'Success'};
    final type = res.runtimeType.toString().toLowerCase().contains('list');
    if (response.statusCode < 400) {
      return ResponseModel(
        statusCode: response.statusCode,
        status: true,
        message: type
            ? 'Success'
            : (res as Map<String, dynamic>)['message'].toString(),
        data: res,
        bodyBytes: response.bodyBytes,
        headers: responseHeaders,
      );
    } else {
      return ResponseModel(
        statusCode: response.statusCode,
        status: false,
        message: type
            ? 'Success'
            : (res as Map<String, dynamic>)['message'].toString(),
        bodyBytes: response.bodyBytes,
        headers: responseHeaders,
        data: res,
      );
    }
  } on TimeoutException catch (e) {
    return ResponseModel(
        headers: {},
        message: e.message.toString(),
        status: false,
        statusCode: 408,
        bodyBytes: Uint8List(0));
  } on SocketException catch (e) {
    return ResponseModel(
        headers: {},
        message: e.message,
        status: false,
        statusCode: 408,
        bodyBytes: Uint8List(0));
  } on Exception {
    return ResponseModel(
        headers: {},
        message: 'Connection Problem! 😐',
        status: false,
        statusCode: 500,
        bodyBytes: Uint8List(0));
  }
}
