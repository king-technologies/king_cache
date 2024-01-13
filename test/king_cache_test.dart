import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:king_cache/king_cache.dart';
import 'package:king_cache/response_model.dart';
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

  group('cacheViaRest', () {
    test(
        'Should return data from the api as expected',
        () async => KingCache.cacheViaRest(url,
            onSuccess: (data) => expect(data, equals(response.toString()))));

    test('should return data from API and cache it if cache is not available',
        () async {
      await KingCache.cacheViaRest(url,
          onSuccess: (data) {
            expect(data, equals(res200.data.toString()));
          },
          justApi: true,
          apiResponse: (data) {
            expect(data.data, equals(res200.data));
          });
    });

    test('onSuccess callback should execute 2 times with should update true',
        () async {
      // Arrange
      const url = 'https://jsonplaceholder.typicode.com/todos/2';
      final onSuccess = expectAsync1((x) {}, count: 2);
      final file =
          await KingCache.localFile('httpsjsonplaceholdertypicodecomtodos2');
      if (file == null) {
        expect(true, isFalse);
        return;
      }
      file.writeAsStringSync(res200.data.toString());
      await KingCache.cacheViaRest(url,
          onSuccess: onSuccess, shouldUpdate: true);
    });

    test('should return error if API response is not successful', () async {
      // Arrange
      const url = 'https://jsonplaeholder.typicode.com/todos/1';
      // Act
      await KingCache.cacheViaRest(
        url,
        onSuccess: (x) {},
        onError: (data) => expect(data.status, equals(res400.status)),
        apiResponse: (data) {
          // Assert
          expect(data.status, equals(res400.status));
        },
      );
    });

    test('should update cache if shouldUpdate is true', () async {
      final file =
          await KingCache.localFile('httpsjsonplaceholdertypicodecomtodos1');
      final result = await KingCache.cacheViaRest(
        url,
        onSuccess: (data) {
          expect(data, equals(res200.data.toString()));
        },
        apiResponse: (data) {
          expect(data.data, equals(res200.data));
        },
      );
      expect(result.status, isTrue);
      expect(result.data, equals(res200.data.toString()));

      // Clean up
      if (file == null) {
        expect(true, isFalse);
        return;
      }
      expect(await file.readAsString(), equals(res200.data.toString()));
      await file.delete();
    });

    test('should delete cache if expiryTime is provided and cache has expired',
        () async {
      const url = 'https://jsonplaceholder.typicode.com/todos/1';
      final expiryTime = DateTime.now().subtract(const Duration(hours: 1));
      final file =
          await KingCache.localFile('httpsjsonplaceholdertypicodecomtodos1');
      if (file == null) {
        expect(true, isFalse);
        return;
      }
      await file.writeAsString(res200.data.toString());

      final result = await KingCache.cacheViaRest(
        url,
        onSuccess: (data) {
          expect(data, equals(res200.data.toString()));
        },
        expiryTime: expiryTime,
      );

      expect(result.status, isTrue);
      expect(result.message, equals('Got data from cache'));
      expect(file.existsSync(), true);
      await file.delete();
    });
  });
}
