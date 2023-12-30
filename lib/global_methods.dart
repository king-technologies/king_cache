import 'dart:io';

// Future<Directory?> get tempDirectory async => getTemporaryDirectory();
// Future<Directory?> get appSupportDirectory => getApplicationSupportDirectory();
// Future<Directory?> get appLibraryDirectory => getLibraryDirectory();
// Future<Directory?> get appDocumentsDirectory => getApplicationDocumentsDirectory();
// Future<Directory?> get appCacheDirectory => getApplicationCacheDirectory();
// Future<Directory?> get externalDocumentsDirectory => getExternalStorageDirectory();
// Future<List<Directory>?> get externalStorageDirectories => getExternalStorageDirectories(type: StorageDirectory.alarms);
// Future<List<Directory>?> get externalCacheDirectories => getExternalCacheDirectories();
// Future<Directory?> get downloadsDirectory => getDownloadsDirectory();

bool get applicationDocumentSupport => Platform.isAndroid || Platform.isIOS || Platform.isFuchsia || Platform.isMacOS;
