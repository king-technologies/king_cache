import 'dart:html';
import 'package:flutter/foundation.dart';

import '../king_cache.dart';

Future<void> storeLogExec(String log, {LogLevel level = LogLevel.info}) async {
  if (kIsWeb) {
    await storeLogInIndexedDB(log, level: level);
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

Future<void> storeLogInIndexedDB(String log, {LogLevel level = LogLevel.info}) async {
  final db = await window.indexedDB!.open('logsDB', version: 1,
      onUpgradeNeeded: (e) {
    final db = e.target.result as Database;
    db.createObjectStore('logs', keyPath: 'id', autoIncrement: true);
  });

  final transaction = db.transaction('logs', 'readwrite');
  final store = transaction.objectStore('logs');

  final date = DateTime.now().toLocal();
  final datePart = date.toString().split(' ')[0];
  final timePart =
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  final logLevel = level.toString().split('.').last.toUpperCase();
  log = '$datePart $timePart [$logLevel]: $log';

  store.add({'log': log});
}

Future<String> getLogsFromIndexedDB() async {
  final db = await window.indexedDB!.open('logsDB', version: 1);
  final transaction = db.transaction('logs', 'readonly');
  final store = transaction.objectStore('logs');
  final logs = await store.getAll();
  return logs.map((log) => log['log']).join('\n');
}

Future<void> clearLogsFromIndexedDB() async {
  final db = await window.indexedDB!.open('logsDB', version: 1);
  final transaction = db.transaction('logs', 'readwrite');
  final store = transaction.objectStore('logs');
  await store.clear();
}

Future<void> removeLogFromIndexedDB(int id) async {
  final db = await window.indexedDB!.open('logsDB', version: 1);
  final transaction = db.transaction('logs', 'readwrite');
  final store = transaction.objectStore('logs');
  await store.delete(id);
}
