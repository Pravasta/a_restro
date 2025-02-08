extension TimeExt on num {
  String get timeFormatMMSS {
    int totalSeconds = toInt();
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return "$formattedMinutes:$formattedSeconds";
  }
}
