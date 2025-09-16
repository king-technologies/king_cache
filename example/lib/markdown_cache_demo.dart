import 'package:flutter/material.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  runApp(const MarkdownCacheDemo());
}

class MarkdownCacheDemo extends StatelessWidget {
  const MarkdownCacheDemo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Markdown Cache Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MarkdownCachePage(),
      );
}

class MarkdownCachePage extends StatefulWidget {
  const MarkdownCachePage({super.key});

  @override
  State<MarkdownCachePage> createState() => _MarkdownCachePageState();
}

class _MarkdownCachePageState extends State<MarkdownCachePage> {
  String _logs = '';
  List<TechBookMetadata> _techBooks = [];
  MarkdownContent? _currentChapter;

  @override
  void initState() {
    super.initState();
    _initializeDemo();
  }

  Future<void> _initializeDemo() async {
    await _createSampleTechBook();
    await _loadTechBooks();
    await _updateLogs();
  }

  Future<void> _createSampleTechBook() async {
    // Sample markdown content for chapters
    const chapter1Content = '''
# Chapter 1: Getting Started with Flutter

Welcome to the comprehensive Flutter development guide! This chapter will introduce you to the basics of Flutter development.

## 1.1 What is Flutter?

Flutter is Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.

### Key Features:
- Fast development
- Expressive and flexible UI
- Native performance

## 1.2 Setting Up Your Environment

Before we start coding, let's set up your development environment.

### Prerequisites:
1. Install Flutter SDK
2. Set up your IDE (VS Code or Android Studio)
3. Configure device emulators or connect physical devices

## 1.3 Your First Flutter App

Let's create a simple "Hello World" application to get familiar with Flutter's structure.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Flutter',
      home: Scaffold(
        appBar: AppBar(title: Text('Hello World')),
        body: Center(child: Text('Hello, Flutter!')),
      ),
    );
  }
}
```

This simple app demonstrates the basic structure of a Flutter application.
''';

    const chapter2Content = '''
# Chapter 2: Widgets and Layouts

In this chapter, we'll dive deep into Flutter's widget system and learn how to create beautiful layouts.

## 2.1 Understanding Widgets

Everything in Flutter is a widget. Widgets describe what their view should look like given their current configuration and state.

### Types of Widgets:
- **StatelessWidget**: Immutable widgets
- **StatefulWidget**: Widgets that can change over time

## 2.2 Common Layout Widgets

Flutter provides many layout widgets to help you arrange other widgets.

### Container Widget
The Container widget is one of the most commonly used widgets for layout.

```dart
Container(
  padding: EdgeInsets.all(16.0),
  margin: EdgeInsets.symmetric(vertical: 8.0),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8.0),
  ),
  child: Text('Hello Container'),
)
```

### Column and Row Widgets
These widgets arrange their children in a vertical or horizontal array.

## 2.3 Responsive Design

Learn how to make your Flutter apps look great on different screen sizes.
''';

    const chapter3Content = '''
# Chapter 3: State Management

State management is crucial for building scalable Flutter applications. This chapter covers various approaches.

## 3.1 Local State with setState

The simplest form of state management uses the built-in setState method.

## 3.2 Provider Pattern

Provider is a popular state management solution that uses InheritedWidget.

## 3.3 Bloc Pattern

Business Logic Component (BLoC) pattern separates business logic from UI.

## 3.4 Riverpod

Riverpod is a reactive caching and data-binding framework for Dart and Flutter.
''';

    // Create tech book metadata
    final metadata = TechBookMetadata(
      title: 'Complete Flutter Development Guide',
      author: 'Flutter Expert',
      version: '2.0',
      description:
          'A comprehensive guide to Flutter development covering basics to advanced topics.',
      chapters: [
        TechBookChapter(
          title: 'Getting Started with Flutter',
          chapterId: 'chapter-1',
          cacheKey: 'flutter-guide-chapter-1',
          description: 'Introduction to Flutter development',
          lastUpdated: DateTime.now(),
        ),
        TechBookChapter(
          title: 'Widgets and Layouts',
          chapterId: 'chapter-2',
          cacheKey: 'flutter-guide-chapter-2',
          description: "Deep dive into Flutter's widget system",
          lastUpdated: DateTime.now(),
        ),
        TechBookChapter(
          title: 'State Management',
          chapterId: 'chapter-3',
          cacheKey: 'flutter-guide-chapter-3',
          description: 'Various approaches to managing state in Flutter',
          lastUpdated: DateTime.now(),
        ),
      ],
      cachedDate: DateTime.now(),
      tags: ['flutter', 'mobile', 'development', 'guide'],
    );

    // Cache the tech book and its chapters
    await KingCache().cacheTechBook(metadata);
    await KingCache()
        .cacheTechBookChapter(metadata.title, 'chapter-1', chapter1Content);
    await KingCache()
        .cacheTechBookChapter(metadata.title, 'chapter-2', chapter2Content);
    await KingCache()
        .cacheTechBookChapter(metadata.title, 'chapter-3', chapter3Content);

    // Also cache some standalone markdown content
    await KingCache().cacheMarkdown(
      'quick-reference',
      '''
# Flutter Quick Reference

## Common Widgets
- Container: Layout and decoration
- Text: Display text
- Column/Row: Vertical/horizontal layout
- Stack: Overlapping widgets

## Navigation
- Navigator.push(): Navigate to new screen
- Navigator.pop(): Go back

## State Management
- setState(): Local state
- Provider: Simple state management
- Bloc: Complex state management
''',
      expiryDate: DateTime.now().add(const Duration(days: 7)),
    );
  }

  Future<void> _loadTechBooks() async {
    final books = await KingCache().getAllTechBooks();
    setState(() {
      _techBooks = books;
    });
  }

  Future<void> _loadChapter(String bookTitle, String chapterId) async {
    final chapter = await KingCache().getTechBookChapter(bookTitle, chapterId);
    setState(() {
      _currentChapter = chapter;
    });
  }

  Future<void> _updateLogs() async {
    final logs = await KingCache().getLogs;
    setState(() {
      _logs = logs;
    });
  }

  Future<void> _clearAllMarkdownCache() async {
    await KingCache().clearAllMarkdownCache();
    await _loadTechBooks();
    setState(() {
      _currentChapter = null;
    });
    await _updateLogs();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All markdown cache cleared!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Markdown Cache Demo'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _clearAllMarkdownCache,
              tooltip: 'Clear All Cache',
            ),
          ],
        ),
        body: Column(
          children: [
            // Tech Books List
            Expanded(
              flex: 2,
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cached Tech Books (${_techBooks.length})',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _techBooks.length,
                          itemBuilder: (context, index) {
                            final book = _techBooks[index];
                            return ExpansionTile(
                              title: Text(book.title),
                              subtitle: Text(
                                  'by ${book.author} • ${book.chapters.length} chapters'),
                              children: book.chapters
                                  .map((chapter) => ListTile(
                                        title: Text(chapter.title),
                                        subtitle:
                                            Text(chapter.description ?? ''),
                                        onTap: () => _loadChapter(
                                            book.title, chapter.chapterId),
                                        trailing:
                                            const Icon(Icons.arrow_forward_ios),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Current Chapter Content
            Expanded(
              flex: 3,
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentChapter != null
                            ? 'Chapter: ${_currentChapter!.title ?? "Untitled"}'
                            : 'Select a chapter to view',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      if (_currentChapter != null) ...[
                        Text(
                          'Cached: ${_currentChapter!.cachedDate.toString().substring(0, 16)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (_currentChapter!.headers.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Headers: ${_currentChapter!.headers.take(3).join(", ")}${_currentChapter!.headers.length > 3 ? "..." : ""}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                _currentChapter!.content,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            ),
                          ),
                        ),
                      ] else
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Select a chapter from above to view its content',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Logs
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Cache Logs',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _updateLogs,
                            tooltip: 'Refresh Logs',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _logs.isEmpty ? 'No logs yet...' : _logs,
                              style: const TextStyle(
                                color: Colors.green,
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Demonstrate real-time caching
            await KingCache().cacheMarkdown(
              'dynamic-content-${DateTime.now().millisecondsSinceEpoch}',
              '''
# Dynamic Content

This content was cached at: ${DateTime.now()}

## Features Demonstrated:
- Real-time markdown caching
- Automatic title extraction
- Header parsing
- Expiry handling
''',
              expiryDate: DateTime.now().add(const Duration(minutes: 5)),
            );

            await _updateLogs();

            if (mounted && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dynamic content cached!')),
              );
            }
          },
          tooltip: 'Add Dynamic Content',
          child: const Icon(Icons.add),
        ),
      );
}
