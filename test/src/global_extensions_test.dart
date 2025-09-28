import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_cache/king_cache.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('StringExt tests', () {
    test('toTitleCase', () {
      expect('hello world'.toTitleCase, 'Hello World');
      expect('hello_world'.toTitleCase, 'Hello World');
      expect('hello-world'.toTitleCase, 'Hello World');
    });

    test('toCapitalized', () {
      expect('hello'.toCapitalized, 'Hello');
      expect('Hello'.toCapitalized, 'Hello');
      expect('h'.toCapitalized, 'H');
      expect(''.toCapitalized, '');
    });

    test('removeSpace', () {
      expect('hello world'.removeSpace, 'helloworld');
      expect(' hello   world '.removeSpace, 'helloworld');
    });

    test('toIdentifier', () {
      expect('helloWorld'.toIdentifier, 'HELLO_WORLD');
      expect('HelloWorldTest'.toIdentifier, 'HELLO_WORLD_TEST');
    });

    test('toCapitalizedWords', () {
      expect('helloWorld'.toCapitalizedWords, 'Hello World');
      expect('HelloWorldTest'.toCapitalizedWords, 'Hello World Test');
    });

    test('truncate', () {
      expect('hello world'.truncate(length: 5), 'hello...');
      expect('hello'.truncate(length: 10), 'hello');
    });

    test('getInitials', () {
      expect('John Doe'.getInitials, 'JD');
      expect('Single'.getInitials, 'SI');
    });

    test('isEmail', () {
      expect('test@example.com'.isEmail, true);
      expect('invalid-email'.isEmail, false);
    });
  });

  group('DateTimeExt tests', () {
    final dateTime = DateTime(2023, 12, 20, 12);
    final now = DateTime.now();

    test('getTimeStr', () {
      expect(DateTime(now.year, now.month, now.day, 12, 20).getTimeStr,
          '12:20 PM');
      expect(DateTime(now.year, now.month, now.day - 1, 10, 30).getTimeStr,
          '${(now.day - 1).paddedZero}/${now.month.paddedZero} 10:30 AM');
      expect(DateTime(2023, 7, 2, 10, 30).getTimeStr, '02/07/23 10:30 AM');
      expect(dateTime.getTimeStr, '20/12/23 12:00 PM');
      expect(now.getTimeStr, now.tohhmma);
    });

    test('toMilitaryDateTime', () {
      expect(now.toMilitaryDateTime, now.toHHmm);

      final earlierThisMonth = DateTime(now.year, now.month, now.day - 1);
      expect(earlierThisMonth.toMilitaryDateTime, earlierThisMonth.toddMMM);

      final earlierThisYear = DateTime(now.year, now.month - 1, now.day);
      expect(earlierThisYear.toMilitaryDateTime, earlierThisYear.toddMMM);

      final lastYear = DateTime(now.year - 1, now.month, now.day);
      expect(lastYear.toMilitaryDateTime, lastYear.toddMMMyy);

      final lastDayOfYear = DateTime(now.year - 1, 12, 31, 23, 59);
      expect(lastDayOfYear.toMilitaryDateTime, lastDayOfYear.toddMMMyyHHmm);

      final firstDayOfYear = DateTime(now.year);
      expect(firstDayOfYear.toMilitaryDateTime, firstDayOfYear.toddMMM);

      final leapYearDate = DateTime(2020, 2, 29, 12);
      expect(leapYearDate.toMilitaryDateTime, leapYearDate.toddMMMyyHHmm);

      final midnightToday = DateTime(now.year, now.month, now.day);
      expect(midnightToday.toMilitaryDateTime, midnightToday.toddMMM);

      final noonToday = DateTime(now.year, now.month, now.day, 12);
      expect(noonToday.toMilitaryDateTime, noonToday.toHHmm);

      final endOfDayToday = DateTime(now.year, now.month, now.day, 23, 59);
      expect(endOfDayToday.toMilitaryDateTime, endOfDayToday.toHHmm);

      final differentTimeZone =
          now.toUtc().add(const Duration(hours: 5, minutes: 30));
      expect(differentTimeZone.toMilitaryDateTime, differentTimeZone.toHHmm);

      final dstDate = DateTime(2022, 3, 13, 2).add(const Duration(hours: 1));
      expect(dstDate.toMilitaryDateTime, dstDate.toddMMMyyHHmm);

      final futureDateThisYear = DateTime(now.year, now.month + 1, now.day);
      expect(futureDateThisYear.toMilitaryDateTime, futureDateThisYear.toddMMM);

      final futureDateNextYear = DateTime(now.year + 1, now.month, now.day);
      expect(
          futureDateNextYear.toMilitaryDateTime, futureDateNextYear.toddMMMyy);

      final farFutureDate = DateTime(now.year + 10, now.month, now.day);
      expect(farFutureDate.toMilitaryDateTime, farFutureDate.toddMMMyy);

      final pastDateThisYear = DateTime(now.year, now.month - 1, now.day);
      expect(pastDateThisYear.toMilitaryDateTime, pastDateThisYear.toddMMM);

      final farPastDate = DateTime(now.year - 10, now.month, now.day);
      expect(farPastDate.toMilitaryDateTime, farPastDate.toddMMMyy);
    });

    test('toClockTime', () {
      final now = DateTime.now();
      expect(now.toClockTime, now.tohhmma);

      final earlierThisMonth = DateTime(now.year, now.month, now.day - 1);
      expect(earlierThisMonth.toClockTime, earlierThisMonth.toddMMM);

      final earlierThisYear = DateTime(now.year, now.month - 1, now.day);
      expect(earlierThisYear.toClockTime, earlierThisYear.toddMMM);

      final lastYear = DateTime(now.year - 1, now.month, now.day);
      expect(lastYear.toClockTime, lastYear.toddMMMyy);

      final lastDayOfYear = DateTime(now.year - 1, 12, 31, 23, 59);
      expect(lastDayOfYear.toClockTime, lastDayOfYear.toddMMMyyhhmma);

      final firstDayOfYear = DateTime(now.year);
      expect(firstDayOfYear.toClockTime, firstDayOfYear.toddMMM);

      final leapYearDate = DateTime(2020, 2, 29, 12);
      expect(leapYearDate.toClockTime, leapYearDate.toddMMMyyhhmma);

      final midnightToday = DateTime(now.year, now.month, now.day);
      expect(midnightToday.toClockTime, midnightToday.toddMMM);

      final noonToday = DateTime(now.year, now.month, now.day, 12);
      expect(noonToday.toClockTime, noonToday.tohhmma);

      final endOfDayToday = DateTime(now.year, now.month, now.day, 23, 59);
      expect(endOfDayToday.toClockTime, endOfDayToday.tohhmma);

      final differentTimeZone =
          now.toUtc().add(const Duration(hours: 5, minutes: 30));
      expect(differentTimeZone.toClockTime, differentTimeZone.tohhmma);

      final dstDate = DateTime(2022, 3, 13, 2).add(const Duration(hours: 1));
      expect(dstDate.toClockTime, dstDate.toddMMMyyhhmma);

      final futureDateThisYear = DateTime(now.year, now.month + 1, now.day);
      expect(futureDateThisYear.toClockTime, futureDateThisYear.toddMMM);

      final futureDateNextYear = DateTime(now.year + 1, now.month, now.day);
      expect(futureDateNextYear.toClockTime, futureDateNextYear.toddMMMyy);

      final farFutureDate = DateTime(now.year + 10, now.month, now.day);
      expect(farFutureDate.toClockTime, farFutureDate.toddMMMyy);

      final pastDateThisYear = DateTime(now.year, now.month - 1, now.day);
      expect(pastDateThisYear.toClockTime, pastDateThisYear.toddMMM);

      final farPastDate = DateTime(now.year - 10, now.month, now.day);
      expect(farPastDate.toClockTime, farPastDate.toddMMMyy);
    });

    test('ddMMyyHHmma', () {
      expect(dateTime.toddMMyyhhmma, '20-12-23 12:00 PM');
    });

    test('dd-MM-yy hh:mm a', () {
      expect(dateTime.toddMMhhmma, '20-12 12:00 PM');
    });

    test('ddMMyy', () {
      expect(dateTime.toddMMyy, '20-12-23');
    });

    test('dd_MMM', () {
      expect(dateTime.toddMMM, '20 Dec');
    });

    test('dd_MMMM', () {
      expect(dateTime.toddMMMM, '20 December');
    });

    test('todd', () {
      expect(dateTime.todd, '20');
    });
  });

  group('IntEx tests', () {
    test('toClockTimer', () {
      expect(3660.toClockTimer, '01h 01m');
      expect(3661.toClockTimer, '01h 01m');
      expect(00.toClockTimer, '00s');
      expect(100.toClockTimer, '01m 40s');
      expect(59.toClockTimer, '59s');
      expect(60.toClockTimer, '01m 00s');
      expect(61.toClockTimer, '01m 01s');
      expect(3599.toClockTimer, '59m 59s');
      expect(3600.toClockTimer, '01h 00m');
      expect(3601.toClockTimer, '01h 00m');
      expect(3675.toClockTimer, '01h 01m');
      expect(7322.toClockTimer, '02h 02m');
      const x = -1;
      expect(x.toClockTimer, '00s');
      expect(999999.toClockTimer, '277h 46m');
    });
  });

  group('DurationExt tests', () {
    test('tohhmmORmmss', () {
      expect(const Duration(hours: 1000, minutes: 1, seconds: 1).tohhmmORmmss,
          '1000:01');
      expect(const Duration(hours: 100, minutes: 1, seconds: 1).tohhmmORmmss,
          '100:01');
      expect(const Duration(hours: 1, minutes: 1, seconds: 1).tohhmmORmmss,
          '01:01');
      expect(const Duration(seconds: 3661).tohhmmORmmss, '01:01');
      expect(const Duration(seconds: 59).tohhmmORmmss, '00:59');
      expect(const Duration(seconds: 60).tohhmmORmmss, '01:00');
    });
  });

  group('Global Methods tests', () {
    test('applicationDocumentSupport', () {
      expect(applicationDocumentSupport, Platform.isAndroid);
      expect(applicationDocumentSupport, Platform.isIOS);
      expect(applicationDocumentSupport, Platform.isFuchsia);
      expect(applicationDocumentSupport, Platform.isMacOS);
      expect(applicationDocumentSupport, kIsWeb);
    });

    test('firebaseCrashlyticsSupport', () {
      expect(firebaseCrashlyticsSupport, Platform.isAndroid && kReleaseMode);
      expect(firebaseCrashlyticsSupport, Platform.isIOS && kReleaseMode);
      expect(!firebaseCrashlyticsSupport, Platform.isWindows);
    });

    test('windowManagerSupport', () {
      if (Platform.isWindows) {
        expect(windowManagerSupport, Platform.isWindows);
      } else if (Platform.isLinux) {
        expect(windowManagerSupport, Platform.isLinux);
      } else if (Platform.isMacOS) {
        expect(windowManagerSupport, Platform.isMacOS);
      } else {
        expect(windowManagerSupport, isFalse);
      }
      expect(windowManagerSupport, isDesktop);
    });

    test('isMobile', () {
      expect(isMobile, Platform.isAndroid);
      expect(isMobile, Platform.isIOS);
    });

    test('isDesktop', () {
      if (Platform.isWindows) {
        expect(isDesktop, Platform.isWindows);
      } else if (Platform.isLinux) {
        expect(isDesktop, Platform.isLinux);
      } else if (Platform.isMacOS) {
        expect(isDesktop, Platform.isMacOS);
      } else {
        expect(isDesktop, isFalse);
      }
      expect(isDesktop, windowManagerSupport);
    });

    test('inAppUpdateSupport', () {
      expect(inAppUpdateSupport, isFalse);
    });

    test('githubApkReleaseSupport', () {
      expect(githubApkReleaseSupport, isFalse);
    });

    test('ktCheckForPlayStoreUpdate', () async {
      final result = await ktCheckForPlayStoreUpdate;
      expect(result, isFalse);
    });
  });
}
