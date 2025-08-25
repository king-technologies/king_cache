import 'package:flutter_test/flutter_test.dart';
import 'package:king_cache/king_cache.dart';

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
        '''# Integration Test

This markdown is cached alongside traditional cache.

## Features
- Works with existing system
- No conflicts
- Clean separation
''',
      );
      
      // Verify both work
      final traditionalValue = await KingCache().getCache('traditional-key');
      final markdownContent = await KingCache().getMarkdownContent('integration-test');
      
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
      // This test verifies that our new enums work with web caching
      
      // Check that new IndexedDB keys are available
      expect(IndexedDbKeys.values.contains(IndexedDbKeys.markdown), isTrue);
      expect(IndexedDbKeys.values.contains(IndexedDbKeys.techBookMeta), isTrue);
      
      // Check that new file types are available
      expect(FilesTypes.values.contains(FilesTypes.markdown), isTrue);
      expect(FilesTypes.values.contains(FilesTypes.techBookMeta), isTrue);
      
      // Verify file extensions
      expect(FilesTypes.markdown.file, equals('markdown.md'));
      expect(FilesTypes.techBookMeta.file, equals('tech_book_meta.json'));
    });

    test('should handle complex tech book workflow', () async {
      // Create a comprehensive tech book
      final metadata = TechBookMetadata(
        title: 'Complete Flutter Guide',
        author: 'Flutter Team',
        version: '3.0',
        description: 'The definitive guide to Flutter development',
        chapters: [
          TechBookChapter(
            title: 'Introduction',
            chapterId: 'intro',
            cacheKey: 'flutter-guide-intro',
            description: 'Getting started with Flutter',
            sections: [
              const TechBookSection(
                title: 'What is Flutter?',
                sectionId: 'what-is-flutter',
                cacheKey: 'flutter-guide-intro-what',
                description: 'Understanding Flutter framework',
              ),
              const TechBookSection(
                title: 'Setting up Environment',
                sectionId: 'setup',
                cacheKey: 'flutter-guide-intro-setup',
                description: 'Development environment setup',
              ),
            ],
            lastUpdated: DateTime.now(),
          ),
          TechBookChapter(
            title: 'Advanced Concepts',
            chapterId: 'advanced',
            cacheKey: 'flutter-guide-advanced',
            description: 'Advanced Flutter patterns',
            lastUpdated: DateTime.now(),
          ),
        ],
        cachedDate: DateTime.now(),
        tags: ['flutter', 'mobile', 'ui', 'dart'],
      );
      
      // Cache the book and chapters
      await KingCache().cacheTechBook(metadata);
      
      await KingCache().cacheTechBookChapter(
        metadata.title,
        'intro',
        '''# Introduction to Flutter

Flutter is Google's UI toolkit for building beautiful, natively compiled applications.

## What is Flutter?

Flutter is a revolutionary framework that allows developers to create stunning applications.

### Key Benefits:
- Single codebase for multiple platforms
- Fast development cycle
- Beautiful UIs
- Native performance

## Setting up Environment

Let's get your development environment ready.

### Requirements:
1. Flutter SDK
2. Dart SDK (included with Flutter)
3. IDE (VS Code or Android Studio)
4. Device or emulator
''',
      );
      
      await KingCache().cacheTechBookChapter(
        metadata.title,
        'advanced',
        '''# Advanced Flutter Concepts

This chapter covers advanced patterns and techniques.

## State Management

Understanding different state management approaches.

### Provider Pattern
Provider is a wrapper around InheritedWidget.

### Bloc Pattern
Business Logic Component pattern for complex state.

## Performance Optimization

Tips for optimizing your Flutter applications.
''',
      );
      
      // Verify everything is cached correctly
      final cachedBook = await KingCache().getTechBook(metadata.title);
      expect(cachedBook, isNotNull);
      expect(cachedBook!.chapters.length, equals(2));
      expect(cachedBook.tags.length, equals(4));
      
      final introChapter = await KingCache().getTechBookChapter(metadata.title, 'intro');
      expect(introChapter, isNotNull);
      expect(introChapter!.title, equals('Introduction to Flutter'));
      expect(introChapter.headers.length, greaterThan(3));
      
      final advancedChapter = await KingCache().getTechBookChapter(metadata.title, 'advanced');
      expect(advancedChapter, isNotNull);
      expect(advancedChapter!.title, equals('Advanced Flutter Concepts'));
      
      // Test retrieval of all books
      final allBooks = await KingCache().getAllTechBooks();
      expect(allBooks.length, equals(1));
      expect(allBooks.first.title, equals(metadata.title));
      
      // Test removal
      await KingCache().removeTechBook(metadata.title);
      
      final removedBook = await KingCache().getTechBook(metadata.title);
      expect(removedBook, isNull);
      
      final removedChapter = await KingCache().getTechBookChapter(metadata.title, 'intro');
      expect(removedChapter, isNull);
    });

    test('should maintain logging for all operations', () async {
      // Clear logs first
      await KingCache().clearLog;
      
      // Perform various markdown operations
      await KingCache().cacheMarkdown('test-md', '# Test\nContent here');
      
      final metadata = TechBookMetadata(
        title: 'Test Book',
        author: 'Test Author',
        version: '1.0',
        description: 'Test description',
        chapters: [],
        cachedDate: DateTime.now(),
      );
      
      await KingCache().cacheTechBook(metadata);
      await KingCache().cacheTechBookChapter('Test Book', 'ch1', '# Chapter 1\nContent');
      
      // Check that operations were logged
      final logs = await KingCache().getLogs;
      expect(logs.contains('Cached markdown content with key: test-md'), isTrue);
      expect(logs.contains('Cached tech book: Test Book'), isTrue);
      expect(logs.contains('Cached chapter ch1 for book: Test Book'), isTrue);
      
      // Test removal logging
      await KingCache().removeMarkdownContent('test-md');
      await KingCache().removeTechBook('Test Book');
      
      final finalLogs = await KingCache().getLogs;
      expect(finalLogs.contains('Removed markdown content with key: test-md'), isTrue);
      expect(finalLogs.contains('Removed tech book: Test Book'), isTrue);
    });
  });
}