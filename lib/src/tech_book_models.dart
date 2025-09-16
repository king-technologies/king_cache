part of '../king_cache.dart';

/// Represents metadata for a tech book.
class TechBookMetadata {
  /// Creates a new TechBookMetadata instance.
  const TechBookMetadata({
    required this.title,
    required this.author,
    required this.version,
    required this.description,
    required this.chapters,
    required this.cachedDate,
    this.tags = const [],
  });

  /// Creates a TechBookMetadata instance from a JSON map.
  factory TechBookMetadata.fromJson(Map<String, dynamic> json) =>
      TechBookMetadata(
        title: json['title'] as String,
        author: json['author'] as String,
        version: json['version'] as String,
        description: json['description'] as String,
        chapters: (json['chapters'] as List<dynamic>)
            .map((chapter) =>
                TechBookChapter.fromJson(chapter as Map<String, dynamic>))
            .toList(),
        cachedDate: DateTime.parse(json['cachedDate'] as String),
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      );

  /// The title of the tech book.
  final String title;

  /// The author(s) of the tech book.
  final String author;

  /// The version or edition of the tech book.
  final String version;

  /// The description of the tech book.
  final String description;

  /// List of chapters in the tech book.
  final List<TechBookChapter> chapters;

  /// The date when the book was cached.
  final DateTime cachedDate;

  /// Optional tags for categorization.
  final List<String> tags;

  /// Converts the TechBookMetadata instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'version': version,
        'description': description,
        'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
        'cachedDate': cachedDate.toIso8601String(),
        'tags': tags,
      };

  /// Creates a copy of this TechBookMetadata with optionally updated values.
  TechBookMetadata copyWith({
    String? title,
    String? author,
    String? version,
    String? description,
    List<TechBookChapter>? chapters,
    DateTime? cachedDate,
    List<String>? tags,
  }) =>
      TechBookMetadata(
        title: title ?? this.title,
        author: author ?? this.author,
        version: version ?? this.version,
        description: description ?? this.description,
        chapters: chapters ?? this.chapters,
        cachedDate: cachedDate ?? this.cachedDate,
        tags: tags ?? this.tags,
      );
}

/// Represents a chapter in a tech book.
class TechBookChapter {
  /// Creates a new TechBookChapter instance.
  const TechBookChapter({
    required this.title,
    required this.chapterId,
    required this.cacheKey,
    this.description,
    this.sections = const [],
    required this.lastUpdated,
  });

  /// Creates a TechBookChapter instance from a JSON map.
  factory TechBookChapter.fromJson(Map<String, dynamic> json) =>
      TechBookChapter(
        title: json['title'] as String,
        chapterId: json['chapterId'] as String,
        cacheKey: json['cacheKey'] as String,
        description: json['description'] as String?,
        sections: (json['sections'] as List<dynamic>?)
                ?.map((section) =>
                    TechBookSection.fromJson(section as Map<String, dynamic>))
                .toList() ??
            [],
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );

  /// The title of the chapter.
  final String title;

  /// The chapter number or identifier.
  final String chapterId;

  /// The cache key for this chapter's content.
  final String cacheKey;

  /// Optional description of the chapter.
  final String? description;

  /// List of sections within this chapter.
  final List<TechBookSection> sections;

  /// The date when this chapter was last updated.
  final DateTime lastUpdated;

  /// Converts the TechBookChapter instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'title': title,
        'chapterId': chapterId,
        'cacheKey': cacheKey,
        'description': description,
        'sections': sections.map((section) => section.toJson()).toList(),
        'lastUpdated': lastUpdated.toIso8601String(),
      };
}

/// Represents a section within a tech book chapter.
class TechBookSection {
  /// Creates a new TechBookSection instance.
  const TechBookSection({
    required this.title,
    required this.sectionId,
    required this.cacheKey,
    this.description,
  });

  /// Creates a TechBookSection instance from a JSON map.
  factory TechBookSection.fromJson(Map<String, dynamic> json) =>
      TechBookSection(
        title: json['title'] as String,
        sectionId: json['sectionId'] as String,
        cacheKey: json['cacheKey'] as String,
        description: json['description'] as String?,
      );

  /// The title of the section.
  final String title;

  /// The section identifier.
  final String sectionId;

  /// The cache key for this section's content.
  final String cacheKey;

  /// Optional description of the section.
  final String? description;

  /// Converts the TechBookSection instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'title': title,
        'sectionId': sectionId,
        'cacheKey': cacheKey,
        'description': description,
      };
}

/// Represents cached markdown content with metadata.
class MarkdownContent {
  /// Creates a new MarkdownContent instance.
  const MarkdownContent({
    required this.content,
    required this.cacheKey,
    this.title,
    this.headers = const [],
    required this.cachedDate,
    this.expiryDate,
  });

  /// Creates a MarkdownContent instance from a JSON map.
  factory MarkdownContent.fromJson(Map<String, dynamic> json) =>
      MarkdownContent(
        content: json['content'] as String,
        cacheKey: json['cacheKey'] as String,
        title: json['title'] as String?,
        headers: (json['headers'] as List<dynamic>?)?.cast<String>() ?? [],
        cachedDate: DateTime.parse(json['cachedDate'] as String),
        expiryDate: json['expiryDate'] != null
            ? DateTime.parse(json['expiryDate'] as String)
            : null,
      );

  /// The raw markdown content.
  final String content;

  /// The cache key for this content.
  final String cacheKey;

  /// Optional extracted title from the markdown.
  final String? title;

  /// Optional extracted headers from the markdown.
  final List<String> headers;

  /// The date when this content was cached.
  final DateTime cachedDate;

  /// Optional expiry date for the cached content.
  final DateTime? expiryDate;

  /// Converts the MarkdownContent instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'content': content,
        'cacheKey': cacheKey,
        'title': title,
        'headers': headers,
        'cachedDate': cachedDate.toIso8601String(),
        'expiryDate': expiryDate?.toIso8601String(),
      };

  /// Checks if the cached content has expired.
  bool get isExpired =>
      expiryDate != null && DateTime.now().isAfter(expiryDate!);

  /// Extracts headers from markdown content.
  static List<String> extractHeaders(String markdownContent) {
    final headers = <String>[];
    final lines = markdownContent.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('#')) {
        final header = trimmed.replaceFirst(RegExp(r'^#+\s*'), '');
        if (header.isNotEmpty) {
          headers.add(header);
        }
      }
    }

    return headers;
  }

  /// Extracts the first title (H1) from markdown content.
  static String? extractTitle(String markdownContent) {
    final lines = markdownContent.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('# ')) {
        return trimmed.substring(2).trim();
      }
    }

    return null;
  }
}
