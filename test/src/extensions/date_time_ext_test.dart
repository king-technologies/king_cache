import 'package:flutter_test/flutter_test.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  final now = DateTime.now();

  // ─────────────────────────────────────────────────
  // Shared fixed dates used across groups
  // ─────────────────────────────────────────────────
  final d = DateTime(2023, 7, 7, 14, 30, 45); // Friday
  final midnight = DateTime(2023, 7, 7);
  final noon = DateTime(2023, 7, 7, 12);
  final oneAm = DateTime(2023, 7, 7, 1, 5);

  group('DateTimeExt — Time-only Formats', () {
    test('toHHmm — 24-hour HH:mm', () {
      expect(d.toHHmm, '14:30');
      expect(midnight.toHHmm, '00:00');
      expect(noon.toHHmm, '12:00');
    });

    test('toHHmmss — 24-hour HH:mm:ss', () {
      expect(d.toHHmmss, '14:30:45');
      expect(midnight.toHHmmss, '00:00:00');
    });

    test('tohhmma — 12-hour hh:mm a', () {
      expect(d.tohhmma, '02:30 PM');
      expect(midnight.tohhmma, '12:00 AM');
      expect(noon.tohhmma, '12:00 PM');
      expect(oneAm.tohhmma, '01:05 AM');
      expect(DateTime(2023, 7, 7, 23, 59).tohhmma, '11:59 PM');
    });

    test('tohhmmssa — 12-hour with seconds', () {
      expect(d.tohhmmssa, '02:30:45 PM');
      expect(midnight.tohhmmssa, '12:00:00 AM');
    });

    test('tohmma — 12-hour without leading zero', () {
      expect(d.tohmma, '2:30 PM');
      expect(oneAm.tohmma, '1:05 AM');
      expect(noon.tohmma, '12:00 PM');
    });

    test('toMeridiem — AM/PM only', () {
      expect(d.toMeridiem, 'PM');
      expect(midnight.toMeridiem, 'AM');
      expect(noon.toMeridiem, 'PM');
      expect(oneAm.toMeridiem, 'AM');
    });
  });

  group('DateTimeExt — Day Formats', () {
    test('tod — day without leading zero', () {
      expect(d.tod, '7');
      expect(DateTime(2023, 7, 15).tod, '15');
      expect(DateTime(2023, 7).tod, '1');
    });

    test('todd — day with leading zero', () {
      expect(d.todd, '07');
      expect(DateTime(2023, 7, 15).todd, '15');
      expect(DateTime(2023, 7).todd, '01');
    });

    test('dayOfYear — 1-based day of year', () {
      expect(DateTime(2023).dayOfYear, 1);
      expect(DateTime(2023, 12, 31).dayOfYear, 365);
      expect(DateTime(2024, 12, 31).dayOfYear, 366); // leap year
      expect(DateTime(2023, 7, 7).dayOfYear, 188);
    });
  });

  group('DateTimeExt — Weekday Formats', () {
    // 2023-07-07 is a Friday
    final friday = DateTime(2023, 7, 7);
    final monday = DateTime(2023, 7, 3);
    final sunday = DateTime(2023, 7, 9);
    final saturday = DateTime(2023, 7, 8);

    test('toEEEE — full weekday name', () {
      expect(friday.toEEEE, 'Friday');
      expect(monday.toEEEE, 'Monday');
      expect(sunday.toEEEE, 'Sunday');
      expect(saturday.toEEEE, 'Saturday');
    });

    test('toEEE — abbreviated weekday name', () {
      expect(friday.toEEE, 'Fri');
      expect(monday.toEEE, 'Mon');
      expect(sunday.toEEE, 'Sun');
      expect(saturday.toEEE, 'Sat');
    });

    test('toEEEEE — narrow weekday (single letter)', () {
      expect(friday.toEEEEE, 'F');
      expect(monday.toEEEEE, 'M');
      expect(sunday.toEEEEE, 'S');
    });

    test('toWeekdayNumber — ISO weekday (1=Mon, 7=Sun)', () {
      expect(monday.toWeekdayNumber, 1);
      expect(friday.toWeekdayNumber, 5);
      expect(saturday.toWeekdayNumber, 6);
      expect(sunday.toWeekdayNumber, 7);
    });

    test('isWeekend / isWeekday', () {
      expect(friday.isWeekend, isFalse);
      expect(friday.isWeekday, isTrue);
      expect(saturday.isWeekend, isTrue);
      expect(saturday.isWeekday, isFalse);
      expect(sunday.isWeekend, isTrue);
      expect(monday.isWeekend, isFalse);
    });
  });

  group('DateTimeExt — Month Formats', () {
    test('toM — month without leading zero', () {
      expect(d.toM, '7');
      expect(DateTime(2023).toM, '1');
      expect(DateTime(2023, 12).toM, '12');
    });

    test('toMM — month with leading zero', () {
      expect(d.toMM, '07');
      expect(DateTime(2023).toMM, '01');
      expect(DateTime(2023, 12).toMM, '12');
    });

    test('toMMM — abbreviated month name', () {
      expect(d.toMMM, 'Jul');
      expect(DateTime(2023).toMMM, 'Jan');
      expect(DateTime(2023, 12).toMMM, 'Dec');
      expect(DateTime(2023, 2).toMMM, 'Feb');
    });

    test('toMMMM — full month name', () {
      expect(d.toMMMM, 'July');
      expect(DateTime(2023).toMMMM, 'January');
      expect(DateTime(2023, 12).toMMMM, 'December');
      expect(DateTime(2023, 2).toMMMM, 'February');
    });

    test('toMMMMM — narrow month (single letter)', () {
      expect(d.toMMMMM, 'J'); // July → J
      expect(DateTime(2023).toMMMMM, 'J'); // January → J
      expect(DateTime(2023, 3).toMMMMM, 'M'); // March → M
    });
  });

  group('DateTimeExt — Year Formats', () {
    test('toyy — 2-digit year', () {
      expect(d.toyy, '23');
      expect(DateTime(2000).toyy, '00');
      expect(DateTime(2024).toyy, '24');
      expect(now.toyy, now.year.toString().substring(2));
    });

    test('toyyyy — 4-digit year', () {
      expect(d.toyyyy, '2023');
      expect(DateTime(2000).toyyyy, '2000');
      expect(DateTime(2024).toyyyy, '2024');
    });
  });

  group('DateTimeExt — Week & Quarter', () {
    test('weekOfYear — ISO week number', () {
      expect(DateTime(2023).weekOfYear, 1);
      expect(DateTime(2023, 1, 9).weekOfYear, greaterThanOrEqualTo(1));
      expect(DateTime(2023, 12, 31).weekOfYear, greaterThan(50));
    });

    test('quarter — Q1–Q4', () {
      expect(DateTime(2023).quarter, 1);
      expect(DateTime(2023, 3, 31).quarter, 1);
      expect(DateTime(2023, 4).quarter, 2);
      expect(DateTime(2023, 6, 30).quarter, 2);
      expect(DateTime(2023, 7).quarter, 3);
      expect(DateTime(2023, 9, 30).quarter, 3);
      expect(DateTime(2023, 10).quarter, 4);
      expect(DateTime(2023, 12, 31).quarter, 4);
    });

    test('toQuarterStr — label', () {
      expect(DateTime(2023, 1, 15).toQuarterStr, 'Q1 2023');
      expect(DateTime(2023, 4, 15).toQuarterStr, 'Q2 2023');
      expect(DateTime(2023, 7, 15).toQuarterStr, 'Q3 2023');
      expect(DateTime(2023, 10, 15).toQuarterStr, 'Q4 2023');
    });
  });

  group('DateTimeExt — Date-only Formats', () {
    test('toddMMM', () => expect(d.toddMMM, '07 Jul'));
    test('toddMMMM', () => expect(d.toddMMMM, '07 July'));
    test('toddMMMyy', () => expect(d.toddMMMyy, '07 Jul 23'));
    test('toddMMMyyyy', () => expect(d.toddMMMyyyy, '07 Jul 2023'));
    test('toddMMMMyyyy', () => expect(d.toddMMMMyyyy, '07 July 2023'));
    test('toddMMyy', () => expect(d.toddMMyy, '07-07-23'));
    test('toddMMyyyy', () => expect(d.toddMMyyyy, '07-07-2023'));
    test('toISO8601Date', () => expect(d.toISO8601Date, '2023-07-07'));
    test('toddMMyyyySlash', () => expect(d.toddMMyyyySlash, '07/07/2023'));
    test('toMMddyyyySlash', () => expect(d.toMMddyyyySlash, '07/07/2023'));
    test('toMMMyyyy', () => expect(d.toMMMyyyy, 'Jul 2023'));
    test('toMMMMyyyy', () => expect(d.toMMMMyyyy, 'July 2023'));
  });

  group('DateTimeExt — Weekday + Date Combined', () {
    // 2023-07-07 = Friday
    test('toEEEddMMM', () => expect(d.toEEEddMMM, 'Fri 07 Jul'));
    test('toEEEddMMMyyyy', () => expect(d.toEEEddMMMyyyy, 'Fri, 07 Jul 2023'));
    test('toEEEddMMMMyyyy', () => expect(d.toEEEddMMMMyyyy, 'Fri, 07 July 2023'));
    test('toEEEEddMMMMyyyy',
        () => expect(d.toEEEEddMMMMyyyy, 'Friday, 07 July 2023'));
    test('toEEEEddMMMyy',
        () => expect(d.toEEEEddMMMyy, 'Friday, 07 Jul 23'));
  });

  group('DateTimeExt — Date + Time 24-hour', () {
    test('toddMMMHHmm', () => expect(d.toddMMMHHmm, '07 Jul 14:30'));
    test('toddMMMyyHHmm', () => expect(d.toddMMMyyHHmm, '07 Jul 23 14:30'));
    test('toddMMMyyyy_HHmm',
        () => expect(d.toddMMMyyyyHHmm, '07 Jul 2023 14:30'));
    test('toddMMMMyyyyHHmm',
        () => expect(d.toddMMMMyyyyHHmm, '07 July 2023 14:30'));
    test('toEEEddMMMHHmm', () => expect(d.toEEEddMMMHHmm, 'Fri 07 Jul 14:30'));
    test('toEEEEddMMMMyyyyHHmm',
        () => expect(d.toEEEEddMMMMyyyyHHmm, 'Friday, 07 July 2023 14:30'));
    test('toISO8601DateTime',
        () => expect(d.toISO8601DateTime, '2023-07-07 14:30:45'));
  });

  group('DateTimeExt — Date + Time 12-hour', () {
    test('toddMMhhmma', () => expect(d.toddMMhhmma, '07-07 02:30 PM'));
    test('toddMMMhhmma', () => expect(d.toddMMMhhmma, '07 Jul 02:30 PM'));
    test('toddMMMyyhhmma', () => expect(d.toddMMMyyhhmma, '07 Jul 23 02:30 PM'));
    test('toddMMMyyyy_hhmma',
        () => expect(d.toddMMMyyyyhhmma, '07 Jul 2023 02:30 PM'));
    test('toddMMMMyyyyhhmma',
        () => expect(d.toddMMMMyyyyhhmma, '07 July 2023 02:30 PM'));
    test('toddMMyyhhmma', () => expect(d.toddMMyyhhmma, '07-07-23 02:30 PM'));
    test('toEEEddMMMhhmma',
        () => expect(d.toEEEddMMMhhmma, 'Fri 07 Jul 02:30 PM'));
    test('toEEEEddMMMMyyyyhhmma',
        () => expect(d.toEEEEddMMMMyyyyhhmma, 'Friday, 07 July 2023 02:30 PM'));
  });

  group('DateTimeExt — Contextual Formatters', () {
    final todayNoon = DateTime(now.year, now.month, now.day, 14, 45);
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final lastYearDate = DateTime(now.year - 1, 6, 15, 10, 30);

    group('toMilitaryDateTime', () {
      test('today non-midnight → HH:mm',
          () => expect(todayNoon.toMilitaryDateTime, '14:45'));
      test('today midnight → dd MMM',
          () => expect(todayMidnight.toMilitaryDateTime, todayMidnight.toddMMM));
      test('same year → dd MMM HH:mm', () {
        final sameYear = DateTime(now.year, 3, 1, 9);
        expect(sameYear.toMilitaryDateTime, '${sameYear.toddMMM} 09:00');
      });
      test('different year → dd MMM yy HH:mm',
          () => expect(lastYearDate.toMilitaryDateTime, '15 Jun ${int.parse(now.toyy) - 1} 10:30'));
    });

    group('toClockTime', () {
      test('today non-midnight → hh:mm a',
          () => expect(todayNoon.toClockTime, '02:45 PM'));
      test('today midnight → dd MMM',
          () => expect(todayMidnight.toClockTime, todayMidnight.toddMMM));
      test('same year → dd MMM hh:mm a', () {
        final sameYear = DateTime(now.year, 3, 1, 9);
        expect(sameYear.toClockTime, '${sameYear.toddMMM} 09:00 AM');
      });
      test('different year → dd MMM yy hh:mm a',
          () => expect(lastYearDate.toClockTime, '15 Jun ${int.parse(now.toyy) - 1} 10:30 AM'));
    });

    group('getTimeStr', () {
      test('today → hh:mm a',
          () => expect(todayNoon.getTimeStr, todayNoon.tohhmma));
      test('same year → dd/MM hh:mm a', () {
        final sameYear = DateTime(now.year, 3, 1, 9);
        expect(sameYear.getTimeStr, sameYear.toddMMhhmma.replaceAll('-', '/'));
      });
      test('different year → dd/MM/yy hh:mm a', () {
        expect(lastYearDate.getTimeStr,
            lastYearDate.toddMMyyhhmma.replaceAll('-', '/'));
      });
    });
  });

  group('DateTimeExt — Boolean Utilities', () {
    final todayDate = DateTime(now.year, now.month, now.day, 8);
    final yesterdayDate = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 1));
    final tomorrowDate = DateTime(now.year, now.month, now.day)
        .add(const Duration(days: 1));
    final past = DateTime(2020);

    test('isToday', () {
      expect(todayDate.isToday, isTrue);
      expect(yesterdayDate.isToday, isFalse);
      expect(past.isToday, isFalse);
    });

    test('isYesterday', () {
      expect(yesterdayDate.isYesterday, isTrue);
      expect(todayDate.isYesterday, isFalse);
      expect(past.isYesterday, isFalse);
    });

    test('isTomorrow', () {
      expect(tomorrowDate.isTomorrow, isTrue);
      expect(todayDate.isTomorrow, isFalse);
      expect(past.isTomorrow, isFalse);
    });

    test('isLeapYear', () {
      expect(DateTime(2024).isLeapYear, isTrue);  // div by 4
      expect(DateTime(2000).isLeapYear, isTrue);  // div by 400
      expect(DateTime(1900).isLeapYear, isFalse); // div by 100 not 400
      expect(DateTime(2023).isLeapYear, isFalse);
    });
  });

  group('DateTimeExt — Calendar Utilities', () {
    final date = DateTime(2023, 7, 7, 14, 30); // Friday

    test('daysInMonth', () {
      expect(DateTime(2023).daysInMonth, 31);
      expect(DateTime(2023, 2).daysInMonth, 28); // non-leap
      expect(DateTime(2024, 2).daysInMonth, 29); // leap
      expect(DateTime(2023, 4).daysInMonth, 30);
      expect(DateTime(2023, 7).daysInMonth, 31);
      expect(DateTime(2023, 12).daysInMonth, 31);
    });

    test('startOfDay', () {
      final s = date.startOfDay;
      expect(s.hour, 0);
      expect(s.minute, 0);
      expect(s.second, 0);
      expect(s.day, date.day);
    });

    test('endOfDay', () {
      final e = date.endOfDay;
      expect(e.hour, 23);
      expect(e.minute, 59);
      expect(e.second, 59);
      expect(e.millisecond, 999);
      expect(e.day, date.day);
    });

    test('startOfWeek — Monday', () {
      // 2023-07-07 is Friday, so Monday of that week is 2023-07-03
      final sw = date.startOfWeek;
      expect(sw.weekday, DateTime.monday);
      expect(sw, equals(DateTime(2023, 7, 3, 14, 30)));
    });

    test('endOfWeek — Sunday', () {
      // Sunday of that week is 2023-07-09
      final ew = date.endOfWeek;
      expect(ew.weekday, DateTime.sunday);
      expect(ew, equals(DateTime(2023, 7, 9, 14, 30)));
    });

    test('startOfMonth', () {
      expect(date.startOfMonth, equals(DateTime(2023, 7)));
    });

    test('endOfMonth', () {
      expect(date.endOfMonth, equals(DateTime(2023, 7, 31)));
      expect(DateTime(2023, 2, 10).endOfMonth, equals(DateTime(2023, 2, 28)));
      expect(DateTime(2024, 2, 10).endOfMonth, equals(DateTime(2024, 2, 29)));
    });

    test('startOfYear', () {
      expect(date.startOfYear, equals(DateTime(2023)));
    });

    test('endOfYear', () {
      expect(date.endOfYear, equals(DateTime(2023, 12, 31)));
    });

    test('isSameDay', () {
      expect(date.isSameDay(DateTime(2023, 7, 7, 9)), isTrue);
      expect(date.isSameDay(DateTime(2023, 7, 8)), isFalse);
    });

    test('isSameMonth', () {
      expect(date.isSameMonth(DateTime(2023, 7)), isTrue);
      expect(date.isSameMonth(DateTime(2023, 8, 7)), isFalse);
      expect(date.isSameMonth(DateTime(2022, 7, 7)), isFalse);
    });

    test('isSameYear', () {
      expect(date.isSameYear(DateTime(2023)), isTrue);
      expect(date.isSameYear(DateTime(2024, 7, 7)), isFalse);
    });
  });

  group('DateTimeExt — toRelativeTime', () {
    test('just now — under 60 seconds', () {
      final recent = DateTime.now().subtract(const Duration(seconds: 30));
      expect(recent.toRelativeTime, 'just now');
    });

    test('minutes ago', () {
      final fiveMin = DateTime.now().subtract(const Duration(minutes: 5));
      expect(fiveMin.toRelativeTime, '5 minutes ago');
      final oneMin = DateTime.now().subtract(const Duration(minutes: 1));
      expect(oneMin.toRelativeTime, '1 minute ago');
    });

    test('hours ago', () {
      final threeH = DateTime.now().subtract(const Duration(hours: 3));
      expect(threeH.toRelativeTime, '3 hours ago');
      final oneH = DateTime.now().subtract(const Duration(hours: 1));
      expect(oneH.toRelativeTime, '1 hour ago');
    });

    test('yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.toRelativeTime, 'yesterday');
    });

    test('days ago', () {
      final threeDays = DateTime.now().subtract(const Duration(days: 3));
      expect(threeDays.toRelativeTime, '3 days ago');
    });

    test('last week', () {
      final lastWeek = DateTime.now().subtract(const Duration(days: 8));
      expect(lastWeek.toRelativeTime, 'last week');
    });

    test('weeks ago', () {
      final threeWeeks = DateTime.now().subtract(const Duration(days: 21));
      expect(threeWeeks.toRelativeTime, '3 weeks ago');
    });

    test('months ago', () {
      final twoMonths = DateTime.now().subtract(const Duration(days: 65));
      expect(twoMonths.toRelativeTime, contains('month'));
    });

    test('years ago', () {
      final twoYears = DateTime.now().subtract(const Duration(days: 730));
      expect(twoYears.toRelativeTime, '2 years ago');
      final oneYear = DateTime.now().subtract(const Duration(days: 366));
      expect(oneYear.toRelativeTime, '1 year ago');
    });
  });

  group('DateTimeExt — Edge & Boundary Cases', () {
    test('leap year Feb 29 formats correctly', () {
      final leap = DateTime(2024, 2, 29, 6);
      expect(leap.toddMMM, '29 Feb');
      expect(leap.toddMMMM, '29 February');
      expect(leap.toddMMyy, '29-02-24');
      expect(leap.toddMMyyyy, '29-02-2024');
      expect(leap.tohhmma, '06:00 AM');
      expect(leap.isLeapYear, isTrue);
      expect(leap.daysInMonth, 29);
    });

    test('year-end / year-start boundary', () {
      final dec31 = DateTime(2023, 12, 31, 23, 59);
      final jan1 = DateTime(2024);
      expect(dec31.toddMMMyy, '31 Dec 23');
      expect(jan1.toddMMMyy, '01 Jan 24');
      expect(dec31.toHHmm, '23:59');
      expect(jan1.toHHmm, '00:00');
      expect(dec31.quarter, 4);
      expect(jan1.quarter, 1);
    });

    test('midnight edge cases in contextual formatters', () {
      final midnightToday = DateTime(now.year, now.month, now.day);
      expect(midnightToday.toMilitaryDateTime, midnightToday.toddMMM);
      expect(midnightToday.toClockTime, midnightToday.toddMMM);
    });

    test('midnight of Jan 1 2025 produces correct toMilitaryDateTime', () {
      final jan1 = DateTime(2025);
      // It's not today and year 2025 may or may not equal now.year
      expect(jan1.toMilitaryDateTime, isNotEmpty);
      expect(jan1.toMilitaryDateTime.contains(':'), isFalse); // no time shown
    });

    test('far future date formats without error', () {
      final future = DateTime(9999, 12, 31, 23, 59);
      expect(future.toyyyy, '9999');
      expect(future.toddMMMM, '31 December');
      expect(future.tohhmma, '11:59 PM');
    });

    test('ancient date formats without error', () {
      final ancient = DateTime(1);
      expect(ancient.toHHmm, '00:00');
      expect(ancient.toddMMyy.length, greaterThan(0));
    });

    test('all 12 months produce correct MMM and MMMM values', () {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      final fullMonths = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      for (var i = 1; i <= 12; i++) {
        final date = DateTime(2023, i);
        expect(date.toMMM, months[i - 1]);
        expect(date.toMMMM, fullMonths[i - 1]);
      }
    });

    test('all 7 weekdays produce correct EEE and EEEE', () {
      // 2023-07-03 is Monday
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final fullDays = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
        'Saturday', 'Sunday',
      ];
      for (var i = 0; i < 7; i++) {
        final date = DateTime(2023, 7, 3 + i);
        expect(date.toEEE, days[i]);
        expect(date.toEEEE, fullDays[i]);
        expect(date.toWeekdayNumber, i + 1);
      }
    });
  });

  group('DateTimeExt — Timezone Handling', () {
    test('UTC and local conversion basics', () {
      final utcDate = DateTime.utc(2023, 7, 7, 14, 30);
      final localDate = utcDate.toLocal();
      expect(localDate.isUtc, isFalse);
      expect(utcDate.isUtc, isTrue);
      expect(localDate.year, 2023);
      expect(localDate.month, 7);
    });

    test('local date formatters are non-empty', () {
      final utc = DateTime.utc(now.year, now.month, now.day, 14);
      final local = utc.toLocal();
      expect(local.toHHmm, isNotEmpty);
      expect(local.tohhmma, contains(':'));
      expect(local.toClockTime, contains(':'));
    });
  });

  group('DateTimeExt — Previously Existing Format Regression', () {
    // Ensures no regressions on the original extension surface.
    final testDate = DateTime(2023, 7, 7, 14, 30);

    test('original formats still produce correct output', () {
      expect(testDate.toHHmm, '14:30');
      expect(testDate.tohhmma, '02:30 PM');
      expect(testDate.toddMMM, '07 Jul');
      expect(testDate.toddMMMM, '07 July');
      expect(testDate.toddMMyy, '07-07-23');
      expect(testDate.toddMMMhhmma, '07 Jul 02:30 PM');
      expect(testDate.toddMMMHHmm, '07 Jul 14:30');
      expect(testDate.toddMMMyyhhmma, '07 Jul 23 02:30 PM');
      expect(testDate.toddMMMyyHHmm, '07 Jul 23 14:30');
      expect(testDate.toddMMMyy, '07 Jul 23');
      expect(testDate.toyy, '23');
      expect(testDate.toMMM, 'Jul');
    });

    test('Military/Clock: today vs same year vs different year', () {
      final today = DateTime(now.year, now.month, now.day, 14, 45);
      final sameYear = DateTime(now.year, (now.month == 1 ? 12 : now.month - 1), 3, 14, 45);
      final differentYear = DateTime(now.year - 1, 5, 1, 14, 45);

      expect(today.toMilitaryDateTime, today.toHHmm);
      expect(sameYear.toMilitaryDateTime,
          '${sameYear.toddMMM} ${sameYear.toHHmm}');
      expect(differentYear.toMilitaryDateTime,
          '${differentYear.toddMMMyy} ${differentYear.toHHmm}');

      expect(today.toClockTime, today.tohhmma);
      expect(sameYear.toClockTime,
          '${sameYear.toddMMM} ${sameYear.tohhmma}');
      expect(differentYear.toClockTime,
          '${differentYear.toddMMMyy} ${differentYear.tohhmma}');
    });
  });
}
