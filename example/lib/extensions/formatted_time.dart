extension FormattedTime on Duration {
  String formatToTime() {
    final int hours = inHours;
    final int minutes = inMinutes % 60;
    final int seconds = inSeconds % 60;

    String formattedString =
        '${(hours == 0) ? '' : '${hours.toString().padLeft(2, '0')}:'}'
        '${minutes.toString().padLeft(2, '0')}'
        ':${seconds.toString().padLeft(2, '0')}';

    return formattedString;
  }
}
