import 'package:flutter_test/flutter_test.dart';
import 'package:king_cache/king_cache.dart';
import 'package:king_cache/src/cache_manager.dart';

void main() {
  group('Markdown Cache Integration Tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() async {
      // Clear all cache before each test
      await KingCache().clearAllCache;
      await KingCache().clearLog;
    });

    tearDown(() async {
      // Clean up after each test
      await KingCache().clearAllCache;
      await KingCache().clearLog;
    });

    test('should integrate with existing cache system', () async {
      // Test that markdown caching works alongside traditional caching

      // Cache some traditional content
      await KingCache().setCache('traditional-key', 'traditional-value');

      // Cache some markdown content
      await KingCache().cacheMarkdown(
        'integration-test',
        '''
# Integration Test

This markdown is cached alongside traditional cache.

## Features
- Works with existing system
- No conflicts
- Clean separation
''',
      );

      // Verify both work
      final traditionalValue = await KingCache().getCache('traditional-key');
      final markdownContent =
          await KingCache().getMarkdownContent('integration-test');

      expect(traditionalValue, equals('traditional-value'));
      expect(markdownContent, isNotNull);
      expect(markdownContent!.title, equals('Integration Test'));

      // Check keys are properly separated
      final allKeys = await KingCache().getCacheKeys();
      final markdownKeys = await KingCache().getMarkdownKeys();

      expect(allKeys.contains('traditional-key'), isTrue);
      expect(markdownKeys.contains('integration-test'), isTrue);
      expect(markdownKeys.contains('traditional-key'), isFalse);
    });

    test('should maintain existing cache interface compatibility', () async {
      // Verify that KingCache still implements ICacheManager
      final cache = KingCache();
      expect(cache, isA<ICacheManager>());
      expect(cache, isA<IMarkdownCacheManager>());

      // Test all original methods still work
      await cache.setCache('test', 'value');
      final value = await cache.getCache('test');
      expect(value, equals('value'));

      final hasCache = await cache.hasCache('test');
      expect(hasCache, isTrue);

      await cache.removeCache('test');
      final removed = await cache.getCache('test');
      expect(removed, isNull);

      // Test logging
      await cache.storeLog('Test log entry');
      final logs = await cache.getLogs;
      expect(logs.contains('Test log entry'), isTrue);
    });

    test('should work with web cache manager interface', () async {
      // Check that new file types are available
      expect(FilesTypes.values.contains(FilesTypes.markdown), isTrue);

      // Verify file extensions
      expect(FilesTypes.markdown.file, equals('markdown.md'));
    });
  });
}
