part of '../../king_cache.dart';

/// Extensions for [String] manipulation.
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
