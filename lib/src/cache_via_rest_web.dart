
// import 'package:web/web.dart';

// import '../king_cache.dart';

// Future<ResponseModel> cacheViaRestExecWeb(
//   String url, {
//   void Function(dynamic data)? onSuccess,
//   void Function(bool isHit)? isCacheHit,
//   void Function(ResponseModel data)? onError,
//   void Function(ResponseModel data)? apiResponse,
//   HttpMethod method = HttpMethod.get,
//   Map<String, dynamic>? formData,
//   Map<String, String> headers = const {},
//   bool shouldUpdate = false,
//   DateTime? expiryTime,
//   String? cacheKey,
// }) async {
//   final db = window.indexedDB.open('cacheDB', 1);
//   final key = cacheKey ?? url.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
//   IDBObjectStore? x;
//   if (db.transaction?.db.objectStoreNames.contains(key) == false) {
//     x = db.transaction?.db.createObjectStore(key);
//   } else {
//     final transaction =
//         db.transaction?.db.transaction(key as JSAny, 'readwrite');
//     x = transaction?.objectStore(key);
//   }

//   final data = db.transaction?.db.objectStoreNames.contains('logs') == false;

//   if (isCacheHit != null) {
//     isCacheHit(true);
//   }
//   onSuccess?.call(data);

//   if (!shouldUpdate) {
//     return ResponseModel(
//         headers: {},
//         status: true,
//         message: 'Got data from cache',
//         data: data,
//         bodyBytes: Uint8List(0));
//   }

//   if (expiryTime != null && DateTime.now().isAfter(expiryTime)) {
//     db.transaction?.db.deleteObjectStore(key);
//   }

//   final res = await KingCache.networkRequest(url,
//       formData: formData, method: method, headers: headers);
//   if (apiResponse != null) {
//     apiResponse(res);
//   }
//   if (res.status) {
//     x.add(res.data as JSAny);
//     if (data != res.data) {
//       onSuccess?.call(res.data);
//     }
//   } else {
//     onError?.call(res);
//   }
//   return res;
// }
