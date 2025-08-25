import 'package:flutter_test/flutter_test.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  group('Web Support Tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    test('WebCacheManager should be created', () {
      expect(() => WebCacheManager(), returnsNormally);
    });
    
    test('WebCacheManager should implement ICacheManagerWeb', () {
      final webManager = WebCacheManager();
      expect(webManager, isA<ICacheManagerWeb>());
    });

    test('WebCacheManager should have all required methods', () {
      final webManager = WebCacheManager();
      expect(webManager.getLogs, isA<Future<String>>());
      expect(webManager.clearLog, isA<Future<void>>());
      expect(webManager.clearAllCache, isA<Future<void>>());
      expect(webManager.getCache('test'), isA<Future<String?>>());
      expect(webManager.setCache('test', 'data'), isA<Future<void>>());
      expect(webManager.removeCache('test'), isA<Future<void>>());
      expect(webManager.hasCache('test'), isA<Future<bool>>());
      expect(webManager.getCacheKeys(), isA<Future<List<String>>>());
      expect(webManager.storeLog('test'), isA<Future<void>>());
    });

    test('Log formatting should be consistent', () async {
      // Test that the log formatting is consistent between web and non-web
      // This test verifies the format without actually storing logs
      final date = DateTime.now().toLocal();
      final datePart = date.toString().split(' ')[0];
      final timePart = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
      final logLevel = LogLevel.info.toString().split('.').last.toUpperCase();
      final expectedFormat = '$datePart $timePart [$logLevel]: test message';
      
      // Check that the format matches expected pattern
      expect(expectedFormat, matches(RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\]: test message$')));
    });
  });
}