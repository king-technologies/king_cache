import 'dart:convert';
import 'dart:typed_data';

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

  final res200 = ResponseModel(
    status: true,
    data: response,
    message: 'null',
    bodyBytes: Uint8List(0),
  );

  final res400 = ResponseModel(
    status: false,
    data: response,
    message: 'null',
    bodyBytes: Uint8List(0),
  );
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

    test('set base url and check with api', () async {
      KingCache.setBaseUrl('https://jsonplaceholder.typicode.com/');
      await KingCache.cacheViaRest(
        'todos/1',
        onSuccess: (data) => expect(data, equals(res200.data)),
        apiResponse: (data) => expect(data.data, equals(res200.data)),
        justApi: true,
      );
      await KingCache.clearLog;
    });
  });

  group('Setters Test', () {
    test('set base url', () async {
      KingCache.setBaseUrl('https://jsonplaceholder.typicode.com/');
      expect(KingCache.baseUrl, 'https://jsonplaceholder.typicode.com/');
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

  group('Log Tests', () {
    test('store & get logs', () async {
      await KingCache.storeLog('Call Json Place Holder API');
      final logs = await KingCache.getLogs;
      expect(logs.contains('Call Json Place Holder API'), isTrue);
      await KingCache.clearLog;
    });

    test('clear log', () async {
      await KingCache.storeLog('Call Json Place Holder API');
      await KingCache.clearLog;
      final logs = await KingCache.getLogs;
      expect(logs, '');
    });

    test('Check Time', () async {
      await KingCache.storeLog('Call Json Place Holder API');
      final logs = await KingCache.getLogs;
      final time = logs.split('\n')[0].split(': ')[0];
      expect(time, isNotNull);
      final date = DateTime.parse(time);
      expect(date, isNotNull);
      expect(date.isBefore(DateTime.now()), isTrue);
      expect(date.year, DateTime.now().year);
      expect(date.month, DateTime.now().month);
      expect(date.day, DateTime.now().day);
      expect(date.hour, DateTime.now().hour);
      expect(date.minute, DateTime.now().minute);
      expect(date.second, DateTime.now().second);
      //  2024-01-19 22:18:48
      // Format of the date should be like this
      expect(time, matches(RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$')));
      await KingCache.clearLog;
    });
  });

  group('Checking Network Request', () {
    test('Check Get Network Request', () async {
      final res = await KingCache.networkRequest(url);
      expect(res.status, isTrue);
      expect(jsonEncode(res.data), equals(jsonEncode(res200.data)));
    });

    test('False Test on Network request', () async {
      const url = 'https://jsonplaeholder.typicode.com/todos/1';
      final res = await KingCache.networkRequest(url);
      expect(res.status, isFalse);
    });

    test('Check Post Network Request', () async {
      final res = await KingCache.networkRequest(
          'https://jsonplaceholder.typicode.com/posts',
          method: HttpMethod.post,
          formData: {
            'title': 'foo',
            'body': 'bar',
          });
      expect(res.status, isTrue);
      expect(res.data.toString(), contains('101'));
    });

    test('Check Put Network Request', () async {
      final res = await KingCache.networkRequest(
          'https://jsonplaceholder.typicode.com/posts/1',
          method: HttpMethod.put,
          formData: {
            'title': 'foo',
          });
      expect(res.status, isTrue);
    });

    test('Check Put Network Request', () async {
      final res = await KingCache.networkRequest(
          'https://jsonplaceholder.typicode.com/posts/1',
          method: HttpMethod.patch,
          formData: {
            'title': 'foo',
          });
      expect(res.status, isTrue);
    });

    test('Check Delete Network Request', () async {
      final res = await KingCache.networkRequest(
          'https://jsonplaceholder.typicode.com/posts/1',
          method: HttpMethod.delete);
      expect(res.status, isTrue);
    });
  });

  group('Cache Testings', () {
    test('Check Cache', () async {
      await KingCache.setCache('posts/1', jsonEncode({'title': 'foo'}));
      final res = await KingCache.getCache('posts/1');
      expect(res, jsonEncode({'title': 'foo'}));
    });

    test('Remove Cache', () async {
      await KingCache.setCache('posts/1', jsonEncode({'title': 'foo'}));
      await KingCache.removeCache('posts/1');
      final res = await KingCache.getCache('posts/1');
      expect(res, null);
    });

    test('Check Cache Exists', () async {
      await KingCache.setCache('posts/1', jsonEncode({'title': 'foo'}));
      final res = await KingCache.hasCache('posts/1');
      expect(res, true);
    });

    test('Get Cache Keys', () async {
      final res = await KingCache.getCacheKeys();
      expect(res, isNotNull);
      expect(res, isA<List<String>>());
    });
  });
}
