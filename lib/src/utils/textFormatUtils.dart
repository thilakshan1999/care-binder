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

  static String formatEnum(Enum? e) {
    if (e == null) return '-';
    return formatEnumName(e.name);
  }

  static String formatDate(DateTime? date) {
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

  static String formatDuration(Duration? duration) {
    if (duration == null) return '-';
    if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    }
    return '${duration.inSeconds} second${duration.inSeconds > 1 ? 's' : ''}';
  }
}
