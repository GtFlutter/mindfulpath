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
