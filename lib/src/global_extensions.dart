part of '../king_cache.dart';

extension StringExt on String {
  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .replaceAll('-', ' ')
      .replaceAll('_', ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');

  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String get removeSpace => length > 0
      ? replaceAll(RegExp(r'\s+'), '').replaceAll(RegExp(r'[\s\u00A0]+'), '')
      : '';

  String get toIdentifier => split(RegExp('(?=[A-Z])'))
      .map((e) => e.toCapitalized)
      .join('_')
      .replaceAll('  ', ' ')
      .toUpperCase();

  String get toCapitalizedWords => split(RegExp('(?=[A-Z])'))
      .map((e) => e.toCapitalized)
      .join(' ')
      .replaceAll('  ', ' ');

  String truncate({int length = 7, String omission = '...'}) {
    if (length >= this.length) {
      return this;
    }
    return replaceRange(length, this.length, omission);
  }

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

  bool get isEmail => RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*(\.[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*)*\.[a-zA-Z]{2,}$')
      .hasMatch(this);
}

double getTextWidth(BuildContext context, String text, TextStyle? style) {
  final span = TextSpan(text: text, style: style);
  const constraints = BoxConstraints();
  final richTextWidget = Text.rich(span).build(context) as RichText;
  final renderObject = richTextWidget.createRenderObject(context);
  renderObject.layout(constraints);
  final renderBoxes = renderObject.getBoxesForSelection(
    TextSelection(
      baseOffset: 0,
      extentOffset: TextSpan(text: text).toPlainText().length,
    ),
  );
  return renderBoxes.last.right;
}

extension DateTimeExt on DateTime {
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

  String get toddMMMyyhhmma => DateFormat('dd MMM yy hh:mm a').format(this);
  String get tohhmma => DateFormat('hh:mm a').format(this);
  String get toddMMMhhmma => DateFormat('dd-MM-yy hh:mm a').format(this);

  String get toddMMMHHmm =>
      DateFormat('dd MMM HH:mm').format(this); // 20 Dec 12:00
  String get toddMMMyyHHmm =>
      DateFormat('dd MMM yy HH:mm').format(this); // 20-12-2022 12:00 PM
  String get toHHmm => DateFormat('HH:mm').format(this); // 12:00
  String get toddMMyyhhmma =>
      DateFormat('dd-MM-yy hh:mm a').format(this); // 20-12-2022 12:00 PM
  String get toddMMyy => DateFormat('dd-MM-yy').format(this); // 20-12-2022
  String get toddMMM => DateFormat('dd MMM').format(this); // 20 Dec
  String get toddMMMM => DateFormat('dd MMMM').format(this); // 20 December
  String get todM => DateFormat('dd MMM').format(this); // 12
}

extension IntEx on int {
  String get toClockTimer {
    final sb = StringBuffer();
    final seconds = this;
    if (seconds < 0) {
      return '00s';
    }
    final hours = seconds ~/ 3600;
    if (hours > 0) {
      sb.write('${hours.toString().padLeft(2, '0')}h');
    }
    final minutes = (seconds % 3600) ~/ 60;
    if (minutes > 0 || hours > 0) {
      if (hours > 0) {
        sb.write(' ');
      }
      sb.write('${minutes.toString().padLeft(2, '0')}m');
    }
    final sec = seconds % 60;
    if (sec >= 0 && hours == 0) {
      if (minutes > 0) {
        sb.write(' ');
      }
      sb.write('${sec.toString().padLeft(2, '0')}s');
    }
    return sb.toString();
  }
}

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
