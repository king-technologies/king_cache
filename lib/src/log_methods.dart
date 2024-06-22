import '../king_cache.dart';

Future<void> storeLogExec(String log) async {
  final file = await KingCache().localFile(FilesTypes.log.file);
  final date = DateTime.now().toLocal();
  final datePart = date.toString().split(' ')[0];
  final timePart =
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  log = '$datePart $timePart: $log';
  if (file.existsSync()) {
    final data = file.readAsStringSync();
    if (data.isNotEmpty) {
      file.writeAsStringSync('$data\n$log');
    } else {
      file.writeAsStringSync(log);
    }
  }
}
