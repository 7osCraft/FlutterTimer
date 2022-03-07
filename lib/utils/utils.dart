String durationToString(Duration duration, {bool removeHoursIfZero = false}) {
  String twoDigitMinutes =
      duration.inMinutes.remainder(60).toString().padLeft(2, "0");
  String twoDigitSeconds =
      duration.inSeconds.remainder(60).toString().padLeft(2, "0");

  String hours = duration.inHours == 0 && removeHoursIfZero
      ? ""
      : duration.inHours.toString() + ":";
  return hours + twoDigitMinutes + ":" + twoDigitSeconds;
}
