import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'king_cache.dart';
import 'response_model.dart';

bool get applicationDocumentSupport =>
    Platform.isAndroid ||
    Platform.isIOS ||
    Platform.isFuchsia ||
    Platform.isMacOS;

Future<ResponseModel> networkRequest(
  String url, {
  Map<String, dynamic>? formData,
  HttpMethod method = HttpMethod.get,
  Map<String, String> headers = const {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
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
    }
    final res = response.body.isNotEmpty
        ? jsonDecode(const Utf8Decoder().convert(response.bodyBytes))
            as Map<String, dynamic>
        : {'message': 'Success'};
    if (response.statusCode < 400) {
      return ResponseModel(
        statusCode: response.statusCode,
        status: true,
        message: res['message'].toString(),
        data: res,
      );
    } else {
      return ResponseModel(
        statusCode: response.statusCode,
        status: false,
        message: res['message'].toString(),
      );
    }
  } on TimeoutException catch (e) {
    return ResponseModel(
        message: e.message.toString(), status: false, statusCode: 408);
  } on SocketException catch (e) {
    return ResponseModel(message: e.message, status: false, statusCode: 408);
  } on Exception {
    return const ResponseModel(
        message: 'Connection Problem! 😐', status: false, statusCode: 500);
  }
}
