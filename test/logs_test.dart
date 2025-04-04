import 'package:flutter_test/flutter_test.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  group('Log Tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    test('store & get logs', () async {
      await KingCache().storeLog('Call Json Place Holder API');
      final logs = await KingCache().getLogs;
      expect(logs.contains('Call Json Place Holder API'), isTrue);
      await KingCache().clearLog;
    });

    test('clear log', () async {
      await KingCache().storeLog('Call Json Place Holder API');
      await KingCache().clearLog;
      final logs = await KingCache().getLogs;
      expect(logs, '');
    });

    test('Check Time', () async {
      await KingCache().storeLog('Call Json Place Holder API');
      final logs = await KingCache().getLogs;
      final time = logs.split('\n')[0].split(': ')[0].replaceAll(' [INFO]', '');
      expect(time, isNotNull);
      final date = DateTime.parse(time);
      expect(date, isNotNull);
      expect(date.isBefore(DateTime.now()), isTrue);
      expect(date.year, DateTime.now().year);
      expect(date.month, DateTime.now().month);
      expect(date.day, DateTime.now().day);
      expect(date.hour, DateTime.now().hour);
      expect(date.minute, DateTime.now().minute);
      expect(date.second, DateTime.now().second);
      expect(time, matches(RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$')));
      await KingCache().clearLog;
    });

    test('Log File should be a text file', () async {
      if (isMobile) {
        await KingCache().storeLog('Call Json Place Holder API');
        final file = await KingCache().getLogFile;
        expect(file.path.endsWith('.txt'), isTrue);
        await KingCache().clearLog;
      }
    });

    test('store & get logs with log levels', () async {
      await KingCache().storeLog('Info log');
      await KingCache().storeLog('Debug log', level: LogLevel.debug);
      await KingCache().storeLog('Warning log', level: LogLevel.warning);
      await KingCache().storeLog('Error log', level: LogLevel.error);
      final logs = await KingCache().getLogs;
      expect(logs.contains('[INFO]: Info log'), isTrue);
      expect(logs.contains('[DEBUG]: Debug log'), isTrue);
      expect(logs.contains('[WARNING]: Warning log'), isTrue);
      expect(logs.contains('[ERROR]: Error log'), isTrue);
      expect(logs.contains('[INFO]: Other log'), isFalse);
      expect(logs.contains('[DEBUG]: Other log'), isFalse);
      expect(logs.contains('[WARNING]: Other log'), isFalse);
      expect(logs.contains('[ERROR]: Other log'), isFalse);
      await KingCache().clearLog;
    });
  });
}
