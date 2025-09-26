part of '../king_cache.dart';

/// Enum representing different types of files.
enum FilesTypes {
  /// Log file type.
  log('log.txt'),

  /// Markdown file type for tech books.
  markdown('markdown.md');

  /// Constructor for the enum value.
  const FilesTypes(this.file);

  /// The file associated with the enum value.
  final String file;
}

/// Enum representing different log levels.
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Enum representing different types of indexed db keys.
enum IndexedDbKeys { logs, cache }
