/// Enum representing the types of files.
enum FilesTypes { log }

/// Extension method to get the file name for each FilesTypes enum value.
/// Returns the file name as a string.
extension FilesTypesExtension on FilesTypes {
  String get file {
    switch (this) {
      case FilesTypes.log:
        return 'log.txt';
    }
  }
}
