part of '../../king_cache.dart';

/// Extensions for [DateTime] manipulation.
extension DateTimeExt on DateTime {
  // ─────────────────────────────────────────────────
  // SMART CONTEXTUAL FORMATTERS
  // ─────────────────────────────────────────────────

  /// Returns a formatted string representing the time based on the current date and time.
  ///
  /// - Same day  → `hh:mm a`          e.g. `'12:00 PM'`
  /// - Same year → `dd/MM hh:mm a`    e.g. `'06/07 10:30 AM'`
  /// - Other     → `dd/MM/yy hh:mm a` e.g. `'02/07/23 10:30 AM'`
  String get getTimeStr {
    final now = DateTime.now();
    if (now.day == day && now.month == month && now.year == year) {
      return tohhmma;
    } else if (now.year == year) {
      return toddMMhhmma.replaceAll('-', '/');
    }
    return toddMMyyhhmma.replaceAll('-', '/');
  }

  /// Contextual military (24-hour) date-time string.
  ///
  /// - Today, non-midnight → `HH:mm`           e.g. `'14:45'`
  /// - Today, midnight     → `dd MMM`           e.g. `'03 May'`
  /// - Same year           → `dd MMM HH:mm`     e.g. `'07 Jul 14:45'`
  /// - Different year      → `dd MMM yy HH:mm`  e.g. `'07 Jul 23 14:45'`
  String get toMilitaryDateTime {
    final now = DateTime.now();
    final isMidnight = hour == 0 && minute == 0;
    final timeStr = isMidnight ? '' : ' $toHHmm';
    if (now.day == day && now.month == month && now.year == year) {
      return timeStr.isEmpty ? toddMMM : timeStr.trim();
    }
    if (now.year == year) {
      return toddMMM + timeStr;
    }
    return toddMMMyy + timeStr;
  }

  /// Contextual 12-hour (AM/PM) date-time string.
  ///
  /// - Today, non-midnight → `hh:mm a`          e.g. `'02:45 PM'`
  /// - Today, midnight     → `dd MMM`            e.g. `'03 May'`
  /// - Same year           → `dd MMM hh:mm a`    e.g. `'07 Jul 02:45 PM'`
  /// - Different year      → `dd MMM yy hh:mm a` e.g. `'07 Jul 23 02:45 PM'`
  String get toClockTime {
    final now = DateTime.now();
    final isMidnight = hour == 0 && minute == 0;
    final timeStr = isMidnight ? '' : ' $tohhmma';
    if (now.day == day && now.month == month && now.year == year) {
      return timeStr.isEmpty ? toddMMM : timeStr.trim();
    }
    if (now.year == year) {
      return toddMMM + timeStr;
    }
    return toddMMMyy + timeStr;
  }

  /// Human-readable relative time string (past only).
  ///
  /// Examples: `'just now'`, `'5 minutes ago'`, `'3 hours ago'`,
  /// `'yesterday'`, `'3 days ago'`, `'2 weeks ago'`, `'4 months ago'`, `'2 years ago'`
  String get toRelativeTime {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inSeconds < 60) {
      return 'just now';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    }
    if (diff.inDays == 1) {
      return 'yesterday';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 14) {
      return 'last week';
    }
    if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    }
    final years = (diff.inDays / 365).floor();
    return '$years year${years == 1 ? '' : 's'} ago';
  }

  // ─────────────────────────────────────────────────
  // TIME-ONLY FORMATS
  // ─────────────────────────────────────────────────

  /// `HH:mm` — 24-hour time, e.g. `'14:30'`
  String get toHHmm => DateFormat('HH:mm').format(this);

  /// `HH:mm:ss` — 24-hour time with seconds, e.g. `'14:30:45'`
  String get toHHmmss => DateFormat('HH:mm:ss').format(this);

  /// `hh:mm a` — 12-hour time with AM/PM, e.g. `'02:30 PM'`
  String get tohhmma => DateFormat('hh:mm a').format(this);

  /// `hh:mm:ss a` — 12-hour time with seconds and AM/PM, e.g. `'02:30:45 PM'`
  String get tohhmmssa => DateFormat('hh:mm:ss a').format(this);

  /// `h:mm a` — 12-hour time without leading zero, e.g. `'2:30 PM'`
  String get tohmma => DateFormat('h:mm a').format(this);

  /// `a` — Meridiem only: `'AM'` or `'PM'`
  String get toMeridiem => DateFormat('a').format(this);

  // ─────────────────────────────────────────────────
  // DAY FORMATS
  // ─────────────────────────────────────────────────

  /// `d` — Day of month without leading zero, e.g. `'7'`
  String get tod => DateFormat('d').format(this);

  /// `dd` — Day of month with leading zero, e.g. `'07'`
  String get todd => DateFormat('dd').format(this);

  /// Day of year (1–366), e.g. `188`
  int get dayOfYear => difference(DateTime(year)).inDays + 1;

  // ─────────────────────────────────────────────────
  // WEEKDAY FORMATS
  // ─────────────────────────────────────────────────

  /// `EEEE` — Full weekday name, e.g. `'Monday'`
  String get toEEEE => DateFormat('EEEE').format(this);

  /// `EEE` — Abbreviated weekday name, e.g. `'Mon'`
  String get toEEE => DateFormat('EEE').format(this);

  /// `EEEEE` — Narrow weekday (single letter), e.g. `'M'`
  String get toEEEEE => DateFormat('EEEEE').format(this);

  /// ISO 8601 weekday number (1 = Monday … 7 = Sunday).
  int get toWeekdayNumber => weekday;

  // ─────────────────────────────────────────────────
  // MONTH FORMATS
  // ─────────────────────────────────────────────────

  /// `M` — Month without leading zero, e.g. `'7'`
  String get toM => DateFormat('M').format(this);

  /// `MM` — Month with leading zero, e.g. `'07'`
  String get toMM => DateFormat('MM').format(this);

  /// `MMM` — Abbreviated month name, e.g. `'Jul'`
  String get toMMM => DateFormat('MMM').format(this);

  /// `MMMM` — Full month name, e.g. `'July'`
  String get toMMMM => DateFormat('MMMM').format(this);

  /// `MMMMM` — Narrow month (single letter), e.g. `'J'`
  String get toMMMMM => DateFormat('MMMMM').format(this);

  // ─────────────────────────────────────────────────
  // YEAR FORMATS
  // ─────────────────────────────────────────────────

  /// `yy` — 2-digit year, e.g. `'23'`
  String get toyy => DateFormat('yy').format(this);

  /// `yyyy` — 4-digit year, e.g. `'2023'`
  String get toyyyy => DateFormat('yyyy').format(this);

  // ─────────────────────────────────────────────────
  // WEEK / QUARTER
  // ─────────────────────────────────────────────────

  /// ISO 8601 week number (1–53).
  int get weekOfYear {
    final startOfYear = DateTime(year);
    final firstMonday = startOfYear.weekday == DateTime.monday ? startOfYear : startOfYear.add(Duration(days: (8 - startOfYear.weekday) % 7));
    if (isBefore(firstMonday)) {
      return 1;
    }
    return ((difference(firstMonday).inDays) / 7).floor() + 1;
  }

  /// Quarter of the year (1–4), e.g. `2`
  int get quarter => ((month - 1) ~/ 3) + 1;

  /// Quarter label, e.g. `'Q2 2023'`
  String get toQuarterStr => 'Q$quarter $toyyyy';

  // ─────────────────────────────────────────────────
  // DATE-ONLY COMBINED FORMATS
  // ─────────────────────────────────────────────────

  /// `dd MMM` — e.g. `'07 Jul'`
  String get toddMMM => DateFormat('dd MMM').format(this);

  /// `dd MMMM` — e.g. `'07 July'`
  String get toddMMMM => DateFormat('dd MMMM').format(this);

  /// `dd MMM yy` — e.g. `'07 Jul 23'`
  String get toddMMMyy => DateFormat('dd MMM yy').format(this);

  /// `dd MMM yyyy` — e.g. `'07 Jul 2023'`
  String get toddMMMyyyy => DateFormat('dd MMM yyyy').format(this);

  /// `dd MMMM yyyy` — e.g. `'07 July 2023'`
  String get toddMMMMyyyy => DateFormat('dd MMMM yyyy').format(this);

  /// `dd-MM-yy` — e.g. `'07-07-23'`
  String get toddMMyy => DateFormat('dd-MM-yy').format(this);

  /// `dd-MM-yyyy` — e.g. `'07-07-2023'`
  String get toddMMyyyy => DateFormat('dd-MM-yyyy').format(this);

  /// `yyyy-MM-dd` — ISO 8601 date only, e.g. `'2023-07-07'`
  String get toISO8601Date => DateFormat('yyyy-MM-dd').format(this);

  /// `dd/MM/yyyy` — Slash-separated date, e.g. `'07/07/2023'`
  String get toddMMyyyySlash => DateFormat('dd/MM/yyyy').format(this);

  /// `MM/dd/yyyy` — US-style slash date, e.g. `'07/07/2023'`
  String get toMMddyyyySlash => DateFormat('MM/dd/yyyy').format(this);

  /// `MMM yyyy` — e.g. `'Jul 2023'`
  String get toMMMyyyy => DateFormat('MMM yyyy').format(this);

  /// `MMMM yyyy` — e.g. `'July 2023'`
  String get toMMMMyyyy => DateFormat('MMMM yyyy').format(this);

  // ─────────────────────────────────────────────────
  // WEEKDAY + DATE COMBINED FORMATS
  // ─────────────────────────────────────────────────

  /// `EEE dd MMM` — e.g. `'Fri 07 Jul'`
  String get toEEEddMMM => DateFormat('EEE dd MMM').format(this);

  /// `EEE, dd MMM yyyy` — e.g. `'Fri, 07 Jul 2023'`
  String get toEEEddMMMyyyy => DateFormat('EEE, dd MMM yyyy').format(this);

  /// `EEE, dd MMMM yyyy` — e.g. `'Fri, 07 July 2023'`
  String get toEEEddMMMMyyyy => DateFormat('EEE, dd MMMM yyyy').format(this);

  /// `EEEE dd MMM` — e.g. `'Friday, 07 Jul'`
  String get toEEEEddMMM => DateFormat('EEEE, dd MMM').format(this);

  /// `EEEE, dd MMMM yyyy` — e.g. `'Friday, 07 July 2023'`
  String get toEEEEddMMMMyyyy => DateFormat('EEEE, dd MMMM yyyy').format(this);

  /// `EEEE, dd MMM yy` — e.g. `'Friday, 07 Jul 23'`
  String get toEEEEddMMMyy => DateFormat('EEEE, dd MMM yy').format(this);

  // ─────────────────────────────────────────────────
  // DATE + TIME COMBINED FORMATS (24-hour)
  // ─────────────────────────────────────────────────

  /// `dd MMM HH:mm` — e.g. `'07 Jul 14:30'`
  String get toddMMMHHmm => DateFormat('dd MMM HH:mm').format(this);

  /// `dd MMM yy HH:mm` — e.g. `'07 Jul 23 14:30'`
  String get toddMMMyyHHmm => DateFormat('dd MMM yy HH:mm').format(this);

  /// `dd MMM yyyy HH:mm` — e.g. `'07 Jul 2023 14:30'`
  String get toddMMMyyyyHHmm => DateFormat('dd MMM yyyy HH:mm').format(this);

  /// `dd MMMM yyyy HH:mm` — e.g. `'07 July 2023 14:30'`
  String get toddMMMMyyyyHHmm => DateFormat('dd MMMM yyyy HH:mm').format(this);

  /// `EEE dd MMM HH:mm` — e.g. `'Fri 07 Jul 14:30'`
  String get toEEEddMMMHHmm => DateFormat('EEE dd MMM HH:mm').format(this);

  /// `EEEE, dd MMMM yyyy HH:mm` — e.g. `'Friday, 07 July 2023 14:30'`
  String get toEEEEddMMMMyyyyHHmm => DateFormat('EEEE, dd MMMM yyyy HH:mm').format(this);

  /// `yyyy-MM-dd HH:mm:ss` — Full sortable timestamp, e.g. `'2023-07-07 14:30:45'`
  String get toISO8601DateTime => DateFormat('yyyy-MM-dd HH:mm:ss').format(this);

  // ─────────────────────────────────────────────────
  // DATE + TIME COMBINED FORMATS (12-hour)
  // ─────────────────────────────────────────────────

  /// `dd-MM hh:mm a` — e.g. `'07-07 02:30 PM'`
  String get toddMMhhmma => DateFormat('dd-MM hh:mm a').format(this);

  /// `dd MMM hh:mm a` — e.g. `'07 Jul 02:30 PM'`
  String get toddMMMhhmma => DateFormat('dd MMM hh:mm a').format(this);

  /// `dd MMM yy hh:mm a` — e.g. `'07 Jul 23 02:30 PM'`
  String get toddMMMyyhhmma => DateFormat('dd MMM yy hh:mm a').format(this);

  /// `dd MMM yyyy hh:mm a` — e.g. `'07 Jul 2023 02:30 PM'`
  String get toddMMMyyyyhhmma => DateFormat('dd MMM yyyy hh:mm a').format(this);

  /// `dd MMMM yyyy hh:mm a` — e.g. `'07 July 2023 02:30 PM'`
  String get toddMMMMyyyyhhmma => DateFormat('dd MMMM yyyy hh:mm a').format(this);

  /// `dd-MM-yy hh:mm a` — e.g. `'07-07-23 02:30 PM'`
  String get toddMMyyhhmma => DateFormat('dd-MM-yy hh:mm a').format(this);

  /// `EEE dd MMM hh:mm a` — e.g. `'Fri 07 Jul 02:30 PM'`
  String get toEEEddMMMhhmma => DateFormat('EEE dd MMM hh:mm a').format(this);

  /// `EEEE, dd MMMM yyyy hh:mm a` — e.g. `'Friday, 07 July 2023 02:30 PM'`
  String get toEEEEddMMMMyyyyhhmma => DateFormat('EEEE, dd MMMM yyyy hh:mm a').format(this);

  // ─────────────────────────────────────────────────
  // BOOLEAN UTILITY GETTERS
  // ─────────────────────────────────────────────────

  /// Whether this date is today.
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  /// Whether this date was yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day && yesterday.month == month && yesterday.year == year;
  }

  /// Whether this date is tomorrow.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day && tomorrow.month == month && tomorrow.year == year;
  }

  /// Whether this date falls on a weekend (Saturday or Sunday).
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Whether this date falls on a weekday (Monday–Friday).
  bool get isWeekday => !isWeekend;

  /// Whether this year is a leap year.
  bool get isLeapYear => (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  // ─────────────────────────────────────────────────
  // CALENDAR UTILITY GETTERS
  // ─────────────────────────────────────────────────

  /// Number of days in the current month, e.g. `31`.
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  /// Start of the day (midnight), e.g. `DateTime(2023, 7, 7)`.
  DateTime get startOfDay => DateTime(year, month, day);

  /// End of the day (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// First day (Monday) of the ISO week containing this date.
  DateTime get startOfWeek => subtract(Duration(days: weekday - DateTime.monday));

  /// Last day (Sunday) of the ISO week containing this date.
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6));

  /// First day of the month, e.g. `DateTime(2023, 7, 1)`.
  DateTime get startOfMonth => DateTime(year, month);

  /// Last day of the month, e.g. `DateTime(2023, 7, 31)`.
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  /// First day of the year, e.g. `DateTime(2023, 1, 1)`.
  DateTime get startOfYear => DateTime(year);

  /// Last day of the year, e.g. `DateTime(2023, 12, 31)`.
  DateTime get endOfYear => DateTime(year, 12, 31);

  /// Whether this date is on the same calendar day as [other].
  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  /// Whether this date is in the same calendar month and year as [other].
  bool isSameMonth(DateTime other) => year == other.year && month == other.month;

  /// Whether this date is in the same calendar year as [other].
  bool isSameYear(DateTime other) => year == other.year;
}
