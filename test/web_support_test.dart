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
  });
}