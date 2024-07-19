import 'package:flutter/foundation.dart';

import '../king_cache.dart';

Future<void> storeLogExec(String log, {LogLevel level = LogLevel.info}) async {
  if (kIsWeb) {
    final storage = WebCacheManager();
    await storage.storeLog(log);
    return;
  }
  final file = await KingCache().localFile(FilesTypes.log.file);
  final date = DateTime.now().toLocal();
  final datePart = date.toString().split(' ')[0];
  final timePart =
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  final logLevel = level.toString().split('.').last.toUpperCase();
  log = '$datePart $timePart [$logLevel]: $log';
  if (file.existsSync()) {
    final data = file.readAsStringSync();
    if (data.isNotEmpty) {
      file.writeAsStringSync('$data\n$log');
    } else {
      file.writeAsStringSync(log);
    }
  }
}
