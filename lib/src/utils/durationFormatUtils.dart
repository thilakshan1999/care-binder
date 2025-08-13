class DurationFormatUtils {
  static Duration? parseIso8601Duration(String? input) {
    if (input == null) return null;
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(input);
    if (match == null) return null;

    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  static String formatIso8601Duration(Duration? duration) {
    if (duration == null) return '';
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    final buffer = StringBuffer('PT');
    if (hours > 0) buffer.write('${hours}H');
    if (minutes > 0) buffer.write('${minutes}M');
    if (seconds > 0) buffer.write('${seconds}S');

    // Special case: Duration is zero
    if (buffer.length == 2) buffer.write('0S');

    return buffer.toString();
  }
}
