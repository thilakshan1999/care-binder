class TextFormatUtils {
  TextFormatUtils._(); // private constructor to prevent instantiation

  static String formatEnumName(String name) {
    return name
        .toLowerCase()
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  static List<String> enumListToStringList<T>(List<T> enumList) {
    return [
      ...enumList.map((e) => formatEnumName(e.toString().split('.').last)).toList(),
    ];
  }

  static String formatEnum(Enum? e) {
    if (e == null) return '-';
    return formatEnumName(e.name);
  }

  static String formatDate(
    DateTime? date,
  ) {
    if (date == null) return '-';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day $month $year, $hour:$minute';
  }

  static String formatDuration(Duration? duration) {
    if (duration == null) return '-';

    const int minutesInHour = 60;
    const int hoursInDay = 24;
    const int daysInMonth = 30;

    int totalMinutes = duration.inMinutes;
    int totalHours = duration.inHours;
    int totalDays = totalHours ~/ hoursInDay;
    int months = totalDays ~/ daysInMonth;
    int days = totalDays % daysInMonth;
    int hours = totalHours % hoursInDay;
    int minutes = totalMinutes % minutesInHour;

    final parts = <String>[];

    if (months > 0) parts.add('$months month${months > 1 ? 's' : ''}');
    if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');
    if (hours > 0) parts.add('$hours hour${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes minute${minutes > 1 ? 's' : ''}');

    return parts.isEmpty
        ? '${duration.inSeconds} second${duration.inSeconds > 1 ? 's' : ''}'
        : parts.join(' ');
  }

  static Map<String, dynamic> parseQuantity(String input) {
    input = input.trim();
    if (input.isEmpty) return {'number': null, 'unit': null};

    // Regular expression to separate number and text
    final regex = RegExp(r'^(\d+)(?:\s*(\D.*))?$');
    final match = regex.firstMatch(input);

    if (match == null) {
      // No number found
      return {'number': null, 'unit': input};
    }

    final numberPart = int.tryParse(match.group(1)!);
    final unitPart = match.group(2)?.trim(); // may be null

    return {
      'number': numberPart,
      'unit': unitPart,
    };
  }
}
