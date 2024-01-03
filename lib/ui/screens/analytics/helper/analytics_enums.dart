enum FilterDuration {
  day,
  week,
  month,
  custom;

  static List<FilterDuration> toList() {
    return [
      FilterDuration.day,
      FilterDuration.week,
      FilterDuration.month,
      FilterDuration.custom,
    ];
  }
}

enum ScreenTitles {
  purchased('Purchased'),
  downloaded('Downloaded'),
  currentlyProgress('Currently Progress');

  final String value;
  const ScreenTitles(this.value);

  static List<ScreenTitles> get toList => [purchased, downloaded, currentlyProgress];
}
