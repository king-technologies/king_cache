import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:king_cache/king_cache.dart';
import 'package:mockito/mockito.dart';

class MockNetworkMethods extends Mock implements Client {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const response = {
    'userId': 1,
    'id': 1,
    'title': 'delectus aut autem',
    'completed': false
  };
  const res200 = ResponseModel(status: true, data: response, message: 'null');
  const res400 = ResponseModel(status: false, data: response, message: 'null');
  const url = 'https://jsonplaceholder.typicode.com/todos/1';
  const fileName = 'httpsjsonplaceholdertypicodecomtodos1.json';

  group('cacheViaRest', () {
    test('Should return data from the api as expected', () async {
      await KingCache.cacheViaRest(url,
          onSuccess: (data) =>
              expect(jsonEncode(data), equals(jsonEncode(response))));
      final file = await KingCache.localFile(fileName);
      if (file == null) {
        expect(true, isFalse);
        return;
      }
      expect(file.readAsStringSync(), equals(jsonEncode(response)));
      file.deleteSync();
    });

    test('should return data from API and cache it if cache is not available',
        () async {
      await KingCache.cacheViaRest(url,
          onSuccess: (data) => expect(data, equals(res200.data)),
          justApi: true,
          apiResponse: (data) =>
              expect(jsonEncode(data.data), equals(jsonEncode(response))));
    });

    test('onSuccess callback should execute 2 times with should update true',
        () async {
      final onSuccess =
          expectAsync1((x) => expect(x, equals(res200.data)), count: 2);
      final file = await KingCache.localFile(fileName);
      if (file == null) {
        expect(true, isFalse);
        return;
      }
      file.writeAsStringSync(jsonEncode(res200.data));
      await KingCache.cacheViaRest(url,
          onSuccess: onSuccess, shouldUpdate: true);
      expect(file.readAsStringSync(), equals(jsonEncode(res200.data)));
      file.deleteSync();
    });

    test('should return error if API response is not successful', () async {
      const url = 'https://jsonplaeholder.typicode.com/todos/1';
      await KingCache.cacheViaRest(
        url,
        onSuccess: (x) {},
        onError: (data) => expect(data.status, equals(res400.status)),
        apiResponse: (data) => expect(data.status, equals(res400.status)),
      );

      final file = await KingCache.localFile(
          'httpsjsonplaeholdertypicodecomtodos1.json');
      if (file == null) {
        return;
      }
      file.deleteSync();
    });

    test('should update cache if shouldUpdate is true', () async {
      final file = await KingCache.localFile(fileName);
      final result = await KingCache.cacheViaRest(
        url,
        onSuccess: (data) => expect(data, equals(res200.data)),
        shouldUpdate: true,
        apiResponse: (data) =>
            expect(jsonEncode(data.data), equals(jsonEncode(res200.data))),
      );
      expect(result.status, isTrue);
      expect(jsonEncode(result.data), equals(jsonEncode(res200.data)));

      // Clean up
      if (file == null) {
        expect(true, isFalse);
        return;
      }
      expect(file.readAsStringSync(), equals(jsonEncode(res200.data)));
      file.deleteSync();
    });

    test('should delete cache if expiryTime is provided and cache has expired',
        () async {
      final expiryTime = DateTime.now().subtract(const Duration(hours: 1));
      final file = await KingCache.localFile(fileName);
      if (file == null) {
        expect(true, isFalse);
        return;
      }
      file.writeAsStringSync(jsonEncode(res200.data));
      final result = await KingCache.cacheViaRest(
        url,
        onSuccess: (data) => expect(data, equals(res200.data)),
        expiryTime: expiryTime,
      );
      expect(result.status, isTrue);
      expect(result.message, equals('Got data from cache'));
      expect(file.existsSync(), true);
      file.deleteSync();
    });

    test('set base url', () async {
      KingCache.setBaseUrl('https://jsonplaceholder.typicode.com/');
      expect(KingCache.baseUrl, 'https://jsonplaceholder.typicode.com/');
    });

    test('set base url and check with api', () async {
      KingCache.setBaseUrl('https://jsonplaceholder.typicode.com/');
      await KingCache.cacheViaRest(
        'todos/1',
        onSuccess: (data) => expect(data, equals(res200.data)),
        apiResponse: (data) => expect(data.data, equals(res200.data)),
        justApi: true,
      );
    });

    test('set headers', () async {
      KingCache.setHeaders({'Content-Type': 'application/json'});
      expect(KingCache.newHeaders, {'Content-Type': 'application/json'});
    });

    test('append form data', () {
      KingCache.appendFormData({'token': '1234567890'});
      expect(KingCache.newFormData, {'token': '1234567890'});
    });
  });
}
