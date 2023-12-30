enum HttpMethod { get, post, put, delete }

enum FilesTypes { log }

extension FilesTypesExtension on FilesTypes {
  String get file {
    switch (this) {
      case FilesTypes.log:
        return 'log.txt';
    }
  }
}
