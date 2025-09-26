part of '../king_cache.dart';

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
