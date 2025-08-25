import 'package:flutter_test/flutter_test.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  group('Markdown Caching Tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    const sampleMarkdown = '''# Chapter 1: Getting Started

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

    const sampleMarkdown2 = '''# Chapter 2: Advanced Topics

This chapter covers advanced Flutter concepts.

## Section 2.1: State Management

Understanding state management is crucial.
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
      
      const markdownWithoutTitle = '''## This is not a title
Some content here.
''';
      final noTitle = MarkdownContent.extractTitle(markdownWithoutTitle);
      expect(noTitle, isNull);
    });

    test('should handle markdown content expiry', () async {
      const key = 'expiring-chapter';
      final expiryDate = DateTime.now().add(const Duration(milliseconds: 100));
      
      // Cache with short expiry
      await KingCache().cacheMarkdown(key, sampleMarkdown, expiryDate: expiryDate);
      
      // Should be available immediately
      var content = await KingCache().getMarkdownContent(key);
      expect(content, isNotNull);
      expect(content!.isExpired, isFalse);
      
      // Wait for expiry
      await Future.delayed(const Duration(milliseconds: 150));
      
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

    test('should cache and retrieve tech book metadata', () async {
      final metadata = TechBookMetadata(
        title: 'Flutter Development Guide',
        author: 'John Doe',
        version: '1.0',
        description: 'A comprehensive guide to Flutter development',
        chapters: [
          TechBookChapter(
            title: 'Getting Started',
            chapterId: 'chapter-1',
            cacheKey: 'flutter-guide-chapter-1',
            description: 'Introduction to Flutter',
            lastUpdated: DateTime.now(),
          ),
        ],
        cachedDate: DateTime.now(),
        tags: ['flutter', 'mobile', 'development'],
      );
      
      // Cache tech book
      await KingCache().cacheTechBook(metadata);
      
      // Retrieve and verify
      final retrieved = await KingCache().getTechBook('Flutter Development Guide');
      expect(retrieved, isNotNull);
      expect(retrieved!.title, equals(metadata.title));
      expect(retrieved.author, equals(metadata.author));
      expect(retrieved.version, equals(metadata.version));
      expect(retrieved.chapters.length, equals(1));
      expect(retrieved.tags.length, equals(3));
    });

    test('should cache and retrieve tech book chapters', () async {
      const bookTitle = 'Flutter Guide';
      const chapterId = 'chapter-1';
      
      // Cache chapter
      await KingCache().cacheTechBookChapter(bookTitle, chapterId, sampleMarkdown);
      
      // Retrieve and verify
      final chapter = await KingCache().getTechBookChapter(bookTitle, chapterId);
      expect(chapter, isNotNull);
      expect(chapter!.content, equals(sampleMarkdown));
      expect(chapter.title, equals('Chapter 1: Getting Started'));
    });

    test('should get all tech books', () async {
      final metadata1 = TechBookMetadata(
        title: 'Flutter Guide',
        author: 'Author 1',
        version: '1.0',
        description: 'Description 1',
        chapters: [],
        cachedDate: DateTime.now(),
      );
      
      final metadata2 = TechBookMetadata(
        title: 'Dart Handbook',
        author: 'Author 2',
        version: '2.0',
        description: 'Description 2',
        chapters: [],
        cachedDate: DateTime.now(),
      );
      
      // Cache multiple tech books
      await KingCache().cacheTechBook(metadata1);
      await KingCache().cacheTechBook(metadata2);
      
      // Get all books
      final allBooks = await KingCache().getAllTechBooks();
      expect(allBooks.length, equals(2));
      
      final titles = allBooks.map((book) => book.title).toList();
      expect(titles.contains('Flutter Guide'), isTrue);
      expect(titles.contains('Dart Handbook'), isTrue);
    });

    test('should remove tech book and all its chapters', () async {
      const bookTitle = 'Removable Book';
      
      // Cache book metadata
      final metadata = TechBookMetadata(
        title: bookTitle,
        author: 'Test Author',
        version: '1.0',
        description: 'Test book',
        chapters: [],
        cachedDate: DateTime.now(),
      );
      await KingCache().cacheTechBook(metadata);
      
      // Cache some chapters
      await KingCache().cacheTechBookChapter(bookTitle, 'chapter-1', sampleMarkdown);
      await KingCache().cacheTechBookChapter(bookTitle, 'chapter-2', sampleMarkdown2);
      
      // Verify everything exists
      expect(await KingCache().getTechBook(bookTitle), isNotNull);
      expect(await KingCache().getTechBookChapter(bookTitle, 'chapter-1'), isNotNull);
      expect(await KingCache().getTechBookChapter(bookTitle, 'chapter-2'), isNotNull);
      
      // Remove the book
      await KingCache().removeTechBook(bookTitle);
      
      // Verify everything is removed
      expect(await KingCache().getTechBook(bookTitle), isNull);
      expect(await KingCache().getTechBookChapter(bookTitle, 'chapter-1'), isNull);
      expect(await KingCache().getTechBookChapter(bookTitle, 'chapter-2'), isNull);
    });

    test('should clear all markdown cache', () async {
      // Cache various content
      await KingCache().cacheMarkdown('standalone-md', sampleMarkdown);
      
      final metadata = TechBookMetadata(
        title: 'Test Book',
        author: 'Test Author',
        version: '1.0',
        description: 'Test',
        chapters: [],
        cachedDate: DateTime.now(),
      );
      await KingCache().cacheTechBook(metadata);
      await KingCache().cacheTechBookChapter('Test Book', 'chapter-1', sampleMarkdown);
      
      // Verify content exists
      expect(await KingCache().hasMarkdownContent('standalone-md'), isTrue);
      expect(await KingCache().getTechBook('Test Book'), isNotNull);
      expect(await KingCache().getTechBookChapter('Test Book', 'chapter-1'), isNotNull);
      
      // Clear all markdown cache
      await KingCache().clearAllMarkdownCache();
      
      // Verify everything is cleared
      expect(await KingCache().hasMarkdownContent('standalone-md'), isFalse);
      expect(await KingCache().getTechBook('Test Book'), isNull);
      expect(await KingCache().getTechBookChapter('Test Book', 'chapter-1'), isNull);
      
      final allBooks = await KingCache().getAllTechBooks();
      expect(allBooks.length, equals(0));
      
      final markdownKeys = await KingCache().getMarkdownKeys();
      expect(markdownKeys.length, equals(0));
    });

    test('should handle JSON serialization correctly', () {
      final metadata = TechBookMetadata(
        title: 'Test Book',
        author: 'Test Author',
        version: '1.0',
        description: 'A test book',
        chapters: [
          TechBookChapter(
            title: 'Chapter 1',
            chapterId: 'ch1',
            cacheKey: 'key1',
            description: 'First chapter',
            sections: [
              const TechBookSection(
                title: 'Section 1',
                sectionId: 'sec1',
                cacheKey: 'sec-key1',
                description: 'First section',
              ),
            ],
            lastUpdated: DateTime.parse('2024-01-01T00:00:00.000Z'),
          ),
        ],
        cachedDate: DateTime.parse('2024-01-01T00:00:00.000Z'),
        tags: ['test', 'book'],
      );
      
      // Test serialization
      final json = metadata.toJson();
      expect(json['title'], equals('Test Book'));
      expect(json['chapters'], hasLength(1));
      
      // Test deserialization
      final restored = TechBookMetadata.fromJson(json);
      expect(restored.title, equals(metadata.title));
      expect(restored.author, equals(metadata.author));
      expect(restored.chapters.length, equals(1));
      expect(restored.chapters.first.sections.length, equals(1));
      expect(restored.tags.length, equals(2));
    });
  });
}