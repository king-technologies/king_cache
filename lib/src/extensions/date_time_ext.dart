part of '../../king_cache.dart';

/// Extensions for [DateTime] manipulation.
extension DateTimeExt on DateTime {
  /// Returns a formatted string representing the time based on the current date and time.
  ///
  /// The format of the returned string varies depending on how the current date
  /// compares to the instance date (`day`, `month`, `year`):
  /// - If the current date is the same as the instance date, returns the time in `hh:mm a` format.
  /// - If the current year is the same as the instance year, returns the date and time in `dd/MM hh:mm a` format
  /// - Otherwise, returns the date and time in `dd/MM/yy hh:mm a` format.
  /// Example:
  /// ```dart
  /// DateTime.now().getTimeStr; // Outputs: '12:00 PM'
  /// yesterday.getTimeStr; // Outputs: '06/07 10:30 AM'
  /// final dateTime = DateTime(2023, 7, 2, 10, 30);
  /// final formattedTime = dateTime.getTimeStr; // Outputs: '02/07/23 10:30 AM'
  /// ```
  String get getTimeStr {
    final now = DateTime.now();
    if (now.day == day && now.month == month && now.year == year) {
      return tohhmma;
    } else if (now.year == year) {
      return toddMMhhmma.replaceAll('-', '/');
    }
    return toddMMyyhhmma.replaceAll('-', '/');
  }

  /// Converts the DateTime to a formatted military time based on current time comparison:
  ///
  /// - If the date is today, it returns the time in 'HH:mm' format.
  /// - If the date is in the current year but not today, it returns 'dd MMM HH:mm'.
  /// - If the date is not in the current year, it returns 'dd MMM yy HH:mm'.
  ///
  /// Example:
  /// ```dart
  /// final militaryTime = DateTime.now().toMilitaryDateTime; // Outputs: '12:00' or '07 Jul 23 12:00' or '07 Jul 12:00'
  /// ```
  String get toMilitaryDateTime {
    final now = DateTime.now();
    if (now.day == day && now.month == month && now.year == year) {
      return toHHmm;
    }
    if (now.year == year) {
      return toddMMMHHmm;
    }
    return toddMMMyyHHmm;
  }

  /// Converts the DateTime to a formatted clock time based on current time comparison:
  ///
  /// - If the date is today, it returns the time in 'hh:mm a' format.
  /// - If the date is in the current year but not today, it returns 'dd MMM hh:mm a'.
  /// - If the date is not in the current year, it returns 'dd MMM yy hh:mm a'.
  ///
  /// Example:
  /// ```dart
  /// final clockTime = DateTime.now().toClockTime; // Outputs: '12:00 AM' or '07 Jul 23 12:00 AM' or '07 Jul 12:00 AM'
  /// ```
  String get toClockTime {
    final now = DateTime.now();
    if (now.day == day && now.month == month && now.year == year) {
      return tohhmma;
    }
    if (now.year == year) {
      return toddMMMhhmma;
    }
    return toddMMMyyhhmma;
  }

  /// Returns the time formatted as 'HH:mm', e.g., '12:00'.
  ///
  /// Example:
  /// ```dart
  /// final formattedTime = DateTime.now().toHHmm; // Outputs: '12:00'
  /// ```
  String get toHHmm => DateFormat('HH:mm').format(this);

  /// Returns the date and time formatted as 'dd MMM yy HH:mm', e.g., '20 Dec 22 12:00'.
  ///
  /// Example:
  /// ```dart
  /// final formattedDateTime = DateTime.now().toddMMMyyHHmm; // Outputs: '07 Jul 24 12:00'
  /// ```
  String get toddMMMyyHHmm => DateFormat('dd MMM yy HH:mm').format(this);

  /// Returns the formatted date and time in 'dd MMM yy hh:mm a' format.
  ///
  /// Example:
  /// ```dart
  /// final formattedDateTime = DateTime.now().toddMMMyyhhmma; // Outputs: '07 Jul 23 12:00 AM'
  /// ```
  String get toddMMMyyhhmma => DateFormat('dd MMM yy hh:mm a').format(this);

  /// Returns the formatted time in 'hh:mm a' format.
  ///
  /// Example:
  /// ```dart
  /// final formattedTime = DateTime.now().tohhmma; // Outputs: '12:00 AM'
  /// ```
  String get tohhmma => DateFormat('hh:mm a').format(this);

  /// Returns the formatted date and time in 'dd MMM hh:mm a' format.
  ///
  /// Example:
  /// ```dart
  /// final formattedDateTime = DateTime.now().toddMMMhhmma; // Outputs: '07 Jul 12:00 AM'
  /// ```
  String get toddMMMhhmma => DateFormat('dd MMM hh:mm a').format(this);

  /// Returns the formatted date and time in 'dd MMM HH:mm' format.
  ///
  /// Example:
  /// ```dart
  /// final formattedDateTime = DateTime.now().toddMMMHHmm; // Outputs: '07 Jul 12:00'
  /// ```
  String get toddMMMHHmm => DateFormat('dd MMM HH:mm').format(this);

  /// Returns the formatted date and time in 'dd-MMhh:mm a' format.
  ///
  /// Example:
  /// ```dart
  /// final formattedDateTime = DateTime.now().toddMMhhmma; // Outputs: '07-07 12:00 AM'
  /// ```
  String get toddMMhhmma => DateFormat('dd-MM hh:mm a').format(this);

  /// Returns the formatted date and time in 'dd-MM-yy hh:mm a' format.
  ///
  /// Example:
  /// ```dart
  /// final formattedDateTime = DateTime.now().toddMMyyhhmma; // Outputs: '07-07-23 12:00 AM'
  /// ```
  String get toddMMyyhhmma => DateFormat('dd-MM-yy hh:mm a').format(this);

  /// Returns the formatted date in 'dd-MM-yy' format.
  ///

  /// Returns the formatted date in 'dd-MM-yy' format.
  ///
  /// Example:
  /// ```dart
  /// final formattedDate = DateTime.now().toddMMyy; // Outputs: '07-07-23'
  /// ```
  String get toddMMyy => DateFormat('dd-MM-yy').format(this);

  /// Returns the formatted date in 'dd MMM' format.
  ///
  /// Example:
  /// ```dart
  /// final formattedDate = DateTime.now().toddMMM; // Outputs: '07 Jul'
  /// ```
  String get toddMMM => DateFormat('dd MMM').format(this);

  /// Returns the formatted date in 'dd MMMM' format.
  ///
  /// Example:
  /// ```dart
  /// final formattedDate = DateTime.now().toddMMMM; // Outputs: '07 July'
  /// ```
  String get toddMMMM => DateFormat('dd MMMM').format(this);

  /// Returns the day of the month formatted as 'dd'.
  ///
  /// Example:
  /// ```dart
  /// final dayOfMonth = DateTime.now().todM; // Outputs: '07'
  /// ```
  String get todM => DateFormat('dd').format(this);
}
