import 'package:flutter_test/flutter_test.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  final now = DateTime.now();

  group('DateTimeExt Formatting Tests', () {
    group('toMilitaryDateTime & toClockTime', () {
      test(
          'returns correct formats for today, different year, and midnight cases',
          () {
        final sameDay = DateTime(now.year, now.month, now.day, 14, 45);
        final midnightSameDay = DateTime(now.year, now.month, now.day);
        final lastYear = DateTime(now.year - 1, now.month, now.day, 14, 45);
        final lastYearMidnight = DateTime(now.year - 1, now.month, now.day);

        expect(sameDay.toMilitaryDateTime, equals('14:45'));
        expect(sameDay.toClockTime, equals('02:45 PM'));

        expect(midnightSameDay.toMilitaryDateTime,
            equals('${now.day} ${now.toMMM}'));
        expect(midnightSameDay.toClockTime, equals('${now.day} ${now.toMMM}'));

        expect(lastYear.toMilitaryDateTime,
            equals('${now.day} ${now.toMMM} ${int.parse(now.toyy) - 1} 14:45'));
        expect(
            lastYear.toClockTime,
            equals(
                '${now.day} ${now.toMMM} ${int.parse(now.toyy) - 1} 02:45 PM'));

        expect(lastYearMidnight.toMilitaryDateTime,
            equals('${now.day} ${now.toMMM} ${int.parse(now.toyy) - 1}'));
      });

      test('returns correct formats for fixed date', () {
        final date = DateTime(2024, 7, 7, 14, 45);
        expect(date.toMilitaryDateTime, '07 Jul 24 14:45');
        expect(date.toClockTime, '07 Jul 24 02:45 PM');
        expect(date.toyy, '24');
      });

      test('handles year-end and year-start cases', () {
        final lastDay = DateTime(2023, 12, 31, 23, 59);
        final firstDay = DateTime(2023, 1, 1, 0, 1);

        expect(lastDay.toddMMyy, equals('31-12-23'));
        expect(lastDay.toHHmm, equals('23:59'));

        expect(firstDay.toddMMyy, equals('01-01-23'));
        expect(firstDay.toHHmm, equals('00:01'));
      });
    });

    group('AM/PM and HH:mm Variants', () {
      final testDate = DateTime(2023, 7, 7, 14, 30);

      test('formats time and date in different string patterns', () {
        expect(testDate.toHHmm, equals('14:30'));
        expect(testDate.tohhmma, equals('02:30 PM'));
        expect(testDate.toddMMMyyHHmm, equals('07 Jul 23 14:30'));
        expect(testDate.toddMMMyyhhmma, equals('07 Jul 23 02:30 PM'));
        expect(testDate.toddMMMhhmma, equals('07 Jul 02:30 PM'));
        expect(testDate.toddMMMHHmm, equals('07 Jul 14:30'));
        expect(testDate.toddMMhhmma, equals('07-07 02:30 PM'));
        expect(testDate.toddMMyyhhmma, equals('07-07-23 02:30 PM'));
        expect(testDate.toddMMyy, equals('07-07-23'));
        expect(testDate.toddMMM, equals('07 Jul'));
        expect(testDate.toddMMMM, equals('07 July'));
        expect(testDate.todd, equals('07'));
      });

      test('formats edge hour cases correctly', () {
        expect(DateTime(2023, 7, 7).tohhmma, equals('12:00 AM'));
        expect(DateTime(2023, 7, 7, 12).tohhmma, equals('12:00 PM'));
        expect(DateTime(2023, 7, 7, 1, 5).tohhmma, equals('01:05 AM'));
        final oneMinuteToMidnight = DateTime(2024, 12, 31, 23, 59);
        final midnight = DateTime(2025);
        expect(oneMinuteToMidnight.tohhmma, equals('11:59 PM'));
        expect(midnight.tohhmma, equals('12:00 AM'));
        expect(midnight.toMilitaryDateTime, equals('01 Jan'));
      });

      test('Handles midnight and today correctly', () {
        final midnightToday = DateTime(now.year, now.month, now.day);
        expect(midnightToday.toMilitaryDateTime, equals(midnightToday.toddMMM));
      });
    });

    group('Year, Month, Day Checks', () {
      test('toyy returns correct year suffix', () {
        expect(now.toyy, equals(now.year.toString().substring(2)));
      });

      test('toMMM and toddMMM format correctly', () {
        expect(now.toddMMM, equals('${now.day} ${now.toMMM}'));
      });

      test('Leap year is handled correctly', () {
        final leapYearDate = DateTime(2024, 2, 29, 12);
        expect(leapYearDate.toddMMyy, equals('29-02-24'));
      });
    });

    group('Locale-specific Behavior', () {
      test('Basic US formatting consistency', () {
        final date = DateTime(2023, 7, 7, 14, 30);
        expect(date.toddMMM, equals('07 Jul'));
      });
    });

    group('Timezone Handling', () {
      test('UTC and local time conversion', () {
        final utcDate = DateTime.utc(2023, 7, 7, 14, 30);
        final localDate = utcDate.toLocal();
        expect(localDate.isUtc, isFalse);
        expect(utcDate.isUtc, isTrue);
        expect(localDate.year, equals(2023));
        expect(localDate.month, equals(7));
        expect(localDate.day, equals(7));
        expect(localDate.hour, equals(20));
        expect(localDate.minute, equals(0));
      });
    });

    group('DateTimeExt Formatting', () {
      test('Standard format outputs are correct', () {
        final date = DateTime(2023, 7, 7, 14, 30);
        expect(date.toHHmm, '14:30');
        expect(date.tohhmma, '02:30 PM');
        expect(date.toddMMM, '07 Jul');
        expect(date.toddMMMM, '07 July');
        expect(date.toddMMyy, '07-07-23');
        expect(date.toddMMMhhmma, '07 Jul 02:30 PM');
        expect(date.toddMMMHHmm, '07 Jul 14:30');
        expect(date.toddMMMyyhhmma, '07 Jul 23 02:30 PM');
        expect(date.toddMMMyyHHmm, '07 Jul 23 14:30');
      });

      test('Midnight removes time in formatting', () {
        final midnight = DateTime(now.year, now.month, now.day);
        expect(midnight.toMilitaryDateTime, equals(midnight.toddMMM));
        expect(midnight.toClockTime, equals(midnight.toddMMM));
      });

      test('Military/Clock Time: Today vs. same year vs. different year', () {
        final today = DateTime(now.year, now.month, now.day, 14, 45);
        final sameYearDate = DateTime(now.year, now.month - 1, 3, 14, 45);
        final differentYearDate = DateTime(now.year - 1, 5, 1, 14, 45);

        expect(today.toMilitaryDateTime, equals(today.toHHmm));
        expect(sameYearDate.toMilitaryDateTime,
            equals('${sameYearDate.toddMMM} ${sameYearDate.toHHmm}'));
        expect(
            differentYearDate.toMilitaryDateTime,
            equals(
                '${differentYearDate.toddMMMyy} ${differentYearDate.toHHmm}'));

        expect(today.toClockTime, equals(today.tohhmma));
        expect(sameYearDate.toClockTime,
            equals('${sameYearDate.toddMMM} ${sameYearDate.tohhmma}'));
        expect(
            differentYearDate.toClockTime,
            equals(
                '${differentYearDate.toddMMMyy} ${differentYearDate.tohhmma}'));
      });

      test('Leap year date formats correctly', () {
        final leap = DateTime(2024, 2, 29, 6);
        expect(leap.toddMMM, '29 Feb');
        expect(leap.tohhmma, '06:00 AM');
      });

      test('Edge transition: 23:59 to 00:00 over year change', () {
        final dec31 = DateTime(now.year, 12, 31, 23, 59);
        final jan1 = DateTime(now.year + 1);

        expect(dec31.toMilitaryDateTime.endsWith('23:59'), true);
        expect(jan1.toMilitaryDateTime,
            '${jan1.toddMMM} ${int.parse(jan1.toyy)}'); // no time shown
      });

      test('Far future and ancient dates are still valid', () {
        final ancient = DateTime(1);
        final future = DateTime(9999, 12, 31, 23, 59);

        expect(ancient.toHHmm, '00:00');
        expect(future.tohhmma, '11:59 PM');
        expect(ancient.toddMMyy.length, greaterThan(0));
        expect(future.toddMMMM, '31 December');
      });

      test('UTC date to local behaves as expected', () {
        final utc = DateTime.utc(now.year, now.month, now.day, 14);
        final local = utc.toLocal();

        expect(local.toHHmm, isNotEmpty);
        expect(local.toClockTime, contains(':'));
      });
    });
  });
}
