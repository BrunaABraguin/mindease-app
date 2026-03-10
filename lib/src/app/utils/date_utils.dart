/// Returns the Monday–Sunday week that contains [date].
List<DateTime> getWeekDays(DateTime date) {
  final monday = date.subtract(Duration(days: date.weekday - 1));
  return List.generate(
    7,
    (i) => DateTime(monday.year, monday.month, monday.day + i),
  );
}
