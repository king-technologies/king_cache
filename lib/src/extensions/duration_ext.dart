part of '../../king_cache.dart';

/// Extension for [Duration] manipulation.
extension DurationExt on Duration {
  /// Returns the duration in 'hh:mm or mm:ss' format.
  ///
  /// Example:
  /// ```dart
  /// final duration = Duration(hours: 1, minutes: 2, seconds: 30);
  /// final formattedDuration = duration.tohhmmORmmss; // Outputs: '01:02'
  ///
  /// final smallerDuration = Duration(minutes: 5, seconds: 15);
  /// final smallerFormattedDuration = smallerDuration.tohhmmORmmss; // Outputs: '05:15'
  /// ```
  String get tohhmmORmmss {
    final hours = inHours;
    final minutes = inMinutes.remainder(60).paddedZero;
    if (hours > 0) {
      return '${hours.paddedZero}:$minutes';
    } else {
      return '$minutes:${inSeconds.remainder(60).paddedZero}';
    }
  }

  String get timeDiff {
    if (inHours > 99) {
      return '${inDays.remainder(100).paddedZero}d ${inHours.remainder(24).paddedZero}h ${inMinutes.remainder(60).paddedZero}m ${inSeconds.remainder(60).paddedZero}s';
    } else if (inHours > 24) {
      return '${inDays}d ${inHours.remainder(24).paddedZero}h ${inMinutes.remainder(60).paddedZero}m';
    } else if (inHours > 0) {
      return '${inHours}h ${inMinutes.remainder(60).paddedZero}m ${inSeconds.remainder(60).paddedZero}s';
    } else if (inMinutes > 0) {
      return '${inMinutes.remainder(60).paddedZero}m ${inSeconds.remainder(60).paddedZero}s';
    } else if (inSeconds > 0) {
      return '${inSeconds.remainder(60).paddedZero}s';
    } else if (inSeconds == 0) {
      return 'Present';
    }
    return 'Past';
  }
}
