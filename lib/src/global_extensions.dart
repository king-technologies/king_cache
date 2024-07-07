part of '../king_cache.dart';

/// Extensions for String manipulation.
extension StringExt on String {
  /// Converts the string to title case.
  ///
  /// Example:
  /// ```dart
  /// final titleCase = 'hello world'.toTitleCase; // Outputs: 'Hello World'
  /// ```
  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .replaceAll('-', ' ')
      .replaceAll('_', ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');

  /// Capitalizes the first letter of the string.
  ///
  /// Example:
  /// ```dart
  /// final capitalized = 'hello'.toCapitalized; // Outputs: 'Hello'
  /// ```
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  /// Removes all spaces from the string.
  ///
  /// Example:
  /// ```dart
  /// final noSpace = 'hello world'.removeSpace; // Outputs: 'helloworld'
  /// ```
  String get removeSpace => length > 0
      ? replaceAll(RegExp(r'\s+'), '').replaceAll(RegExp(r'[\s\u00A0]+'), '')
      : '';

  /// Converts the string to an identifier format (e.g., snake_case).
  ///
  /// Example:
  /// ```dart
  /// final identifier = 'userName'.toIdentifier; // Outputs: 'User_Name'
  /// ```
  String get toIdentifier => split(RegExp('(?=[A-Z])'))
      .map((e) => e.toCapitalized)
      .join('_')
      .replaceAll('  ', ' ')
      .toUpperCase();

  /// Converts the string from camelCase to capitalized words.
  ///
  /// Example:
  /// ```dart
  /// final words = 'camelCaseExample'.toCapitalizedWords; // Outputs: 'Camel Case Example'
  /// ```
  String get toCapitalizedWords => split(RegExp('(?=[A-Z])'))
      .map((e) => e.toCapitalized)
      .join(' ')
      .replaceAll('  ', ' ');

  /// Truncates the string to a specified length with an optional omission string.
  ///
  /// Example:
  /// ```dart
  /// final truncated = 'This is a long sentence'.truncate(length: 10); // Outputs: 'This is a...'
  /// ```
  String truncate({int length = 7, String omission = '...'}) {
    if (length >= this.length) {
      return this;
    }
    return replaceRange(length, this.length, omission);
  }

  /// Returns the initials of the string.
  ///
  /// Example:
  /// ```dart
  /// final initials = 'John Doe'.getInitials; // Outputs: 'JD'
  /// ```
  String get getInitials {
    final words = split(' ');
    var initial = '';
    if (words.length == 1) {
      if (words[0].length > 1) {
        if (RegExp(r'[A-Z]').hasMatch(words[0])) {
          initial = '${words[0][0]}${words[0][1]}';
        } else if (RegExp(r'[A-Z]').hasMatch(substring(0, 2))) {
          final splitIndex = indexOf(RegExp(r'[A-Z]'));
          initial = '${words[0][0]}${substring(splitIndex, splitIndex + 1)}';
        } else {
          initial = '${words[0][0]}${words[0][1]}';
        }
      } else {
        initial = words[0][0];
      }
    } else {
      if (words[0].isNotEmpty) {
        initial = words[0][0];
      }
      if (words[1].isNotEmpty) {
        initial += words[1][0];
      }
    }
    return initial.toUpperCase();
  }

  /// Fixes the text width by truncating it to fit within the specified maximum width.
  ///
  /// Example:
  /// ```dart
  /// final fixedText = fixText(context, 100.0, style: TextStyle(fontSize: 16)); // Adjusts text to fit within 100.0 width
  /// ```
  String fixText(BuildContext context, double maxSize, {TextStyle? style}) {
    final sb = StringBuffer();
    final newName = replaceAll(RegExp(r'\(.*?\)'), '');
    if (newName.isNotEmpty) {
      sb.write(newName);
    } else {
      sb.write('');
    }
    var textWidth = getTextWidth(context, sb.toString(), style);
    var count = 0;
    final splitText = sb.toString().split(' ');
    while (textWidth > maxSize) {
      sb.clear();
      for (var i = 0; i < count; i++) {
        sb.write('${splitText[i][0]}${splitText[i][1]}');
        sb.write(' ');
      }
      sb.write(splitText.sublist(count).join(' '));
      textWidth = getTextWidth(context, sb.toString(), style);
      count++;
    }
    return sb.toString();
  }

  /// Checks if the string is a valid email address.
  ///
  /// Example:
  /// ```dart
  /// final isValidEmail = 'user@example.com'.isEmail; // Outputs: true
  /// ```
  bool get isEmail => RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*(\.[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*)*\.[a-zA-Z]{2,}$')
      .hasMatch(this);
}

/// Extensions for DateTime manipulation.
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

  /// Returns the formatted date and time in 'dd-MM-yy hh:mm a' format.
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

/// Extension on [int] to convert seconds into a formatted clock timer string.
///
/// Example:
/// ```dart
/// final timeInSeconds = 3661;
/// final formattedTime = timeInSeconds.toClockTimer; // Outputs: '01h01m01s'
/// ```
extension IntEx on int {
  String get toTwoDigit => this < 10 ? '0$this' : '$this';

  String get toClockTimer {
    final sb = StringBuffer();
    final seconds = this;
    if (seconds < 0) {
      return '00s';
    }
    final hours = seconds ~/ 3600;
    if (hours > 0) {
      sb.write('${hours.toTwoDigit}h');
    }
    final minutes = (seconds % 3600) ~/ 60;
    if (minutes > 0 || hours > 0) {
      if (hours > 0) {
        sb.write(' ');
      }
      sb.write('${minutes.toTwoDigit}m');
    }
    final sec = seconds % 60;
    if (sec >= 0 && hours == 0) {
      if (minutes > 0) {
        sb.write(' ');
      }
      sb.write('${sec.toTwoDigit}s');
    }
    return sb.toString();
  }
}

/// Extension on [Duration] to convert duration into 'MM:SS' or 'HH:MM' format.
///
/// Example:
/// ```dart
/// final duration = Duration(hours: 1, minutes: 2, seconds: 30);
/// final formattedDuration = duration.toMMSS; // Outputs: '01:02'
///
/// final smallerDuration = Duration(minutes: 5, seconds: 15);
/// final smallerFormattedDuration = smallerDuration.toMMSS; // Outputs: '05:15'
/// ```
extension DurationExt on Duration {
  String get toMMSS {
    final seconds = inSeconds % 60;
    final minutes = inMinutes % 60;
    final hours = inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
