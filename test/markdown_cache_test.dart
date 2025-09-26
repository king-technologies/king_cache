import 'package:flutter_test/flutter_test.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  group('Markdown Caching Tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    const sampleMarkdown = '''
# Chapter 1: Getting Started

This is the first chapter of our tech book.

## Section 1.1: Introduction

Welcome to the world of Flutter development.

### Subsection 1.1.1: Prerequisites

Before we begin, make sure you have:
- Flutter SDK installed
- A code editor
- Basic knowledge of Dart

## Section 1.2: Setup

Let's set up our development environment.
''';

    setUp(() async {
      // Clear all cache before each test
      await KingCache().clearAllMarkdownCache();
    });

    tearDown(() async {
      // Clean up after each test
      await KingCache().clearAllMarkdownCache();
      await KingCache().clearLog;
    });

    test('should cache and retrieve markdown content', () async {
      const key = 'test-chapter-1';

      // Cache markdown content
      await KingCache().cacheMarkdown(key, sampleMarkdown);

      // Retrieve and verify
      final content = await KingCache().getMarkdownContent(key);
      expect(content, isNotNull);
      expect(content!.content, equals(sampleMarkdown));
      expect(content.cacheKey, equals(key));
      expect(content.title, equals('Chapter 1: Getting Started'));
      expect(content.headers.length, greaterThan(0));
      expect(content.headers.contains('Chapter 1: Getting Started'), isTrue);
      expect(content.headers.contains('Section 1.1: Introduction'), isTrue);
    });

    test('should extract headers correctly from markdown', () async {
      final headers = MarkdownContent.extractHeaders(sampleMarkdown);
      expect(headers.length, equals(4));
      expect(headers[0], equals('Chapter 1: Getting Started'));
      expect(headers[1], equals('Section 1.1: Introduction'));
      expect(headers[2], equals('Subsection 1.1.1: Prerequisites'));
      expect(headers[3], equals('Section 1.2: Setup'));
    });

    test('should extract title correctly from markdown', () async {
      final title = MarkdownContent.extractTitle(sampleMarkdown);
      expect(title, equals('Chapter 1: Getting Started'));

      const markdownWithoutTitle = '''
## This is not a title
Some content here.
''';
      final noTitle = MarkdownContent.extractTitle(markdownWithoutTitle);
      expect(noTitle, isNull);
    });

    test('should handle markdown content expiry', () async {
      const key = 'expiring-chapter';
      final expiryDate = DateTime.now().add(const Duration(milliseconds: 100));

      // Cache with short expiry
      await KingCache()
          .cacheMarkdown(key, sampleMarkdown, expiryDate: expiryDate);

      // Should be available immediately
      var content = await KingCache().getMarkdownContent(key);
      expect(content, isNotNull);
      expect(content!.isExpired, isFalse);

      // Wait for expiry
      await Future<void>.delayed(const Duration(milliseconds: 150));

      // Should be expired and automatically removed
      content = await KingCache().getMarkdownContent(key);
      expect(content, isNull);
    });

    test('should check if markdown content exists', () async {
      const key = 'existence-test';

      // Should not exist initially
      final existsBefore = await KingCache().hasMarkdownContent(key);
      expect(existsBefore, isFalse);

      // Cache content
      await KingCache().cacheMarkdown(key, sampleMarkdown);

      // Should exist now
      final existsAfter = await KingCache().hasMarkdownContent(key);
      expect(existsAfter, isTrue);
    });

    test('should remove markdown content', () async {
      const key = 'removal-test';

      // Cache content
      await KingCache().cacheMarkdown(key, sampleMarkdown);
      expect(await KingCache().hasMarkdownContent(key), isTrue);

      // Remove content
      await KingCache().removeMarkdownContent(key);
      expect(await KingCache().hasMarkdownContent(key), isFalse);
    });

    test('should get all markdown keys', () async {
      const keys = ['key1', 'key2', 'key3'];

      // Cache multiple markdown contents
      for (final key in keys) {
        await KingCache().cacheMarkdown(key, sampleMarkdown);
      }

      // Get all keys
      final retrievedKeys = await KingCache().getMarkdownKeys();
      expect(retrievedKeys.length, equals(3));
      for (final key in keys) {
        expect(retrievedKeys.contains(key), isTrue);
      }
    });
  });
}
