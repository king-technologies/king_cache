# Markdown Caching for Tech Books

This document provides a comprehensive guide to the markdown caching functionality in King Cache, specifically designed for tech books and documentation.

## Overview

King Cache now supports specialized caching for markdown content with features tailored for technical documentation and educational content. This includes automatic content parsing, structured organization, and expiry management.

## Key Features

### 1. Markdown Content Caching
- Automatic title extraction from H1 headers
- Header structure parsing for navigation
- Content expiry management
- Rich metadata support

### 2. Tech Book Organization
- Hierarchical book structure (Book → Chapter → Section)
- Metadata management (author, version, tags)
- Chapter-level caching and retrieval
- Bulk operations for book management

### 3. Platform Compatibility
- Works seamlessly on mobile, desktop, and web platforms
- Web support via IndexedDB
- Consistent API across all platforms

## Quick Start

### Basic Markdown Caching

```dart
import 'package:king_cache/king_cache.dart';

// Cache markdown content
await KingCache().cacheMarkdown(
  'getting-started',
  '''# Getting Started

This is your first markdown document.

## Prerequisites
- Flutter SDK
- Basic Dart knowledge

## Next Steps
Follow the tutorial below.
''',
  expiryDate: DateTime.now().add(Duration(days: 7)),
);

// Retrieve content
final content = await KingCache().getMarkdownContent('getting-started');
if (content != null && !content.isExpired) {
  print('Title: ${content.title}');
  print('Headers: ${content.headers}');
  print('Content: ${content.content}');
}
```

### Tech Book Management

```dart
// 1. Create book metadata
final bookMetadata = TechBookMetadata(
  title: 'Flutter Development Guide',
  author: 'Expert Developer',
  version: '1.0',
  description: 'Complete guide to Flutter development',
  chapters: [
    TechBookChapter(
      title: 'Introduction',
      chapterId: 'intro',
      cacheKey: 'flutter-intro',
      description: 'Getting started with Flutter',
      lastUpdated: DateTime.now(),
    ),
    TechBookChapter(
      title: 'Widgets',
      chapterId: 'widgets',
      cacheKey: 'flutter-widgets',
      description: 'Understanding Flutter widgets',
      lastUpdated: DateTime.now(),
    ),
  ],
  cachedDate: DateTime.now(),
  tags: ['flutter', 'mobile', 'development'],
);

// 2. Cache the book
await KingCache().cacheTechBook(bookMetadata);

// 3. Cache individual chapters
await KingCache().cacheTechBookChapter(
  'Flutter Development Guide',
  'intro',
  '''# Introduction to Flutter

Welcome to the Flutter development guide!

## What You'll Learn
- Flutter basics
- Widget system
- State management
- Platform integration

Let's get started!
''',
);

// 4. Retrieve book and chapters
final book = await KingCache().getTechBook('Flutter Development Guide');
final introChapter = await KingCache().getTechBookChapter('Flutter Development Guide', 'intro');
```

## API Reference

### Markdown Content Methods

#### `cacheMarkdown(String key, String markdownContent, {DateTime? expiryDate})`
Caches markdown content with automatic parsing.

**Parameters:**
- `key`: Unique identifier for the content
- `markdownContent`: Raw markdown text
- `expiryDate`: Optional expiry date

#### `getMarkdownContent(String key)`
Retrieves cached markdown content.

**Returns:** `MarkdownContent?` - null if not found or expired

#### `removeMarkdownContent(String key)`
Removes specific markdown content from cache.

#### `hasMarkdownContent(String key)`
Checks if markdown content exists and is not expired.

#### `getMarkdownKeys()`
Returns list of all cached markdown content keys.

#### `clearAllMarkdownCache()`
Removes all markdown content and tech books from cache.

### Tech Book Methods

#### `cacheTechBook(TechBookMetadata metadata)`
Caches book metadata and structure.

#### `getTechBook(String title)`
Retrieves book metadata by title.

#### `cacheTechBookChapter(String bookTitle, String chapterId, String markdownContent)`
Caches a specific chapter's content.

#### `getTechBookChapter(String bookTitle, String chapterId)`
Retrieves a specific chapter's content.

#### `getAllTechBooks()`
Returns list of all cached tech books.

#### `removeTechBook(String title)`
Removes entire book and all its chapters.

## Data Models

### TechBookMetadata
```dart
class TechBookMetadata {
  final String title;
  final String author;
  final String version;
  final String description;
  final List<TechBookChapter> chapters;
  final DateTime cachedDate;
  final List<String> tags;
}
```

### TechBookChapter
```dart
class TechBookChapter {
  final String title;
  final String chapterId;
  final String cacheKey;
  final String? description;
  final List<TechBookSection> sections;
  final DateTime lastUpdated;
}
```

### TechBookSection
```dart
class TechBookSection {
  final String title;
  final String sectionId;
  final String cacheKey;
  final String? description;
}
```

### MarkdownContent
```dart
class MarkdownContent {
  final String content;
  final String cacheKey;
  final String? title;        // Extracted from # header
  final List<String> headers; // All headers found
  final DateTime cachedDate;
  final DateTime? expiryDate;
  
  bool get isExpired; // Automatic expiry checking
}
```

## Best Practices

### 1. Content Organization
- Use descriptive cache keys
- Organize content hierarchically with books and chapters
- Include version information for tracking updates

### 2. Cache Management
- Set appropriate expiry dates for content
- Use tags for categorization and search
- Implement regular cleanup for old content

### 3. Performance Optimization
- Cache frequently accessed chapters separately
- Use batch operations when possible
- Monitor cache size and implement rotation if needed

### 4. Content Structure
- Follow consistent markdown formatting
- Use clear header hierarchy (H1 for titles, H2 for sections)
- Include navigation aids in longer documents

## Examples

### Educational Course Content
```dart
// Cache a programming course
final courseMetadata = TechBookMetadata(
  title: 'Dart Programming Course',
  author: 'Programming Academy',
  version: '2.0',
  description: 'Complete Dart programming course for beginners',
  chapters: [
    // Chapter definitions...
  ],
  cachedDate: DateTime.now(),
  tags: ['dart', 'programming', 'course', 'beginner'],
);

await KingCache().cacheTechBook(courseMetadata);

// Cache lessons as chapters
await KingCache().cacheTechBookChapter(
  'Dart Programming Course',
  'lesson-1',
  '''# Lesson 1: Variables and Data Types

Learn about Dart's type system.

## Variable Declaration
```dart
String name = 'Flutter';
int version = 3;
bool isAwesome = true;
```

## Exercises
Try creating your own variables!
''',
);
```

### API Documentation
```dart
// Cache API documentation
await KingCache().cacheMarkdown(
  'api-reference',
  '''# API Reference

## Authentication
All requests require API key in header.

## Endpoints

### GET /users
Returns list of users.

**Parameters:**
- limit: Number of users to return
- offset: Starting position

### POST /users
Creates a new user.
''',
  expiryDate: DateTime.now().add(Duration(hours: 24)),
);
```

### Release Notes
```dart
// Cache release notes with expiry
await KingCache().cacheMarkdown(
  'release-notes-v2.1',
  '''# Release Notes v2.1.0

## New Features
- Markdown caching support
- Tech book organization
- Automatic content parsing

## Bug Fixes
- Fixed cache expiry issues
- Improved web compatibility

## Breaking Changes
None in this release.
''',
  expiryDate: DateTime.now().add(Duration(days: 30)),
);
```

## Migration Guide

If you're upgrading from basic King Cache to use markdown features:

1. **Existing code remains unchanged** - All current functionality is preserved
2. **Add new imports** - No additional imports needed, everything is in `king_cache.dart`
3. **Gradual adoption** - Start using markdown features alongside existing cache operations
4. **Web compatibility** - No changes needed for web support

## Support

For issues or questions about markdown caching:
- Check the [main documentation](README.md)
- Review the [example application](example/lib/markdown_cache_demo.dart)
- Run the test suite to verify functionality
- Join the [Discord community](https://discord.gg/CJU4UNTaFt)