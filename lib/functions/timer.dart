Duration getDurationUntilNextTimeByHour(int hour) {
  final DateTime now = DateTime.now();
  final DateTime nowEleven = DateTime(now.year, now.month, now.day, hour);
  final bool isAfter = now.isAfter(nowEleven);
  Duration difference = now.difference(nowEleven).abs();
  if (isAfter) {
    difference = now
        .difference(
          DateTime(now.year, now.month, now.day + 1, 11),
        )
        .abs();
  }
  return difference;
}
