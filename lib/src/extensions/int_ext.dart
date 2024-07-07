part of '../../king_cache.dart';

/// Extension for [int] manipulation.
extension IntEx on int {
  /// Returns the number as a two-digit string with a leading zero if necessary.
  /// Example:
  /// ```dart
  /// final number = 1;
  /// final paddedNumber = number.paddedZero; // Outputs: '01'
  /// ```
  String get paddedZero => this < 10 ? '0$this' : '$this';

  /// Returns int seconds into a formatted clock timer string.
  ///
  /// Example:
  /// ```dart
  /// final timeInSeconds = 3661;
  /// final formattedTime = timeInSeconds.toClockTimer; // Outputs: '01h 01m 01s'
  /// ```
  String get toClockTimer {
    final sb = StringBuffer();
    final seconds = this;
    if (seconds < 0) {
      return '00s';
    }
    final hours = seconds ~/ 3600;
    if (hours > 0) {
      sb.write('${hours.paddedZero}h');
    }
    final minutes = (seconds % 3600) ~/ 60;
    if (minutes > 0 || hours > 0) {
      if (hours > 0) {
        sb.write(' ');
      }
      sb.write('${minutes.paddedZero}m');
    }
    final sec = seconds % 60;
    if (sec >= 0 && hours == 0) {
      if (minutes > 0) {
        sb.write(' ');
      }
      sb.write('${sec.paddedZero}s');
    }
    return sb.toString();
  }
}
