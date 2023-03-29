class Formatters {
  const Formatters();

  static String formatDuration(Duration duration) {
    final int days = duration.inDays;
    final int hours = duration.inHours % 24;
    final int minutes = duration.inMinutes % 60;
    final int seconds = duration.inSeconds % 60;

    final String formattedString =
        '${(days == 0) ? '' : '${days.toString().padLeft(2, '0')}:'}'
        '${(hours == 0) ? '' : '${hours.toString().padLeft(2, '0')}:'}'
        '${minutes.toString().padLeft(2, '0')}'
        ':${seconds.toString().padLeft(2, '0')}';

    return formattedString;
  }
}
