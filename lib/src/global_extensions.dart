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

  bool get isEmail => RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*(\.[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*)*\.[a-zA-Z]{2,}$')
      .hasMatch(this);
}

extension DateTimeExt on DateTime {
  String get toDateTime {
    if (DateTime.now().day == day) {
      return DateFormat('HH:mm').format(this);
    }
    if (DateTime.now().year == year) {
      return DateFormat('dd MMM HH:mm').format(this);
    }
    return DateFormat('dd MMM yy HH:mm').format(this);
  }
}

extension IntEx on int {
  String get toClockTimer {
    final sb = StringBuffer();
    final seconds = this;
    final hours = seconds ~/ 3600;
    if (hours > 0) {
      sb.write('${hours.toString().padLeft(2, '0')}h ');
    }
    final minutes = (seconds % 3600) ~/ 60;
    if (minutes > 0) {
      if (hours > 0) {
        sb.write('${minutes.toString().padLeft(2, '0')}m ');
      } else {
        sb.write('${minutes}m ');
      }
    }
    final sec = seconds % 60;
    if (sec != 0) {
      if (minutes > 0) {
        sb.write(sec.toString().padLeft(2, '0'));
      } else {
        sb.write('$sec');
      }
      sb.write('s');
    }
    return sb.toString();
  }
}

extension DurationExt on Duration {
  String get toMMSS {
    final sb = StringBuffer();
    final seconds = inSeconds % 60;
    final minutes = inMinutes % 60;
    final hours = inHours;
    if (hours > 0) {
      sb.write('${hours.toString().padLeft(2, '0')}:');
      sb.write(minutes.toString().padLeft(2, '0'));
    } else {
      sb.write('${minutes.toString().padLeft(2, '0')}:');
      sb.write(seconds.toString().padLeft(2, '0'));
    }
    return sb.toString();
  }
}
