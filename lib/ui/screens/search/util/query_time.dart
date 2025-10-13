enum QueryTime {
  ///   Time in min  start_time - end_time
  ///      <30m           0     - 1800
  ///      30m-45m       1800   - 2700
  ///      45m-60m       2700   - 3600
  ///      >60m          null   - 3600
  qTime1(title: '<30m', showTitle: '0-30 min', startTimeInMinutes: 0, endTimeInMinutes: 30),
  qTime2(title: '30m-45m', showTitle: '30-45 min', startTimeInMinutes: 30, endTimeInMinutes: 45),
  qTime3(title: '45m-60m', showTitle: '45-60 min', startTimeInMinutes: 45, endTimeInMinutes: 60),
  qTime4(title: '>60m', showTitle: '60+ min', startTimeInMinutes: 60, endTimeInMinutes: 0);

  final String showTitle;
  final String title;
  final int? startTimeInMinutes;
  final int endTimeInMinutes;

  const QueryTime({required this.title, required this.showTitle, required this.startTimeInMinutes, required this.endTimeInMinutes});
  static List<QueryTime> get toList => [qTime1, qTime2, qTime3, qTime4];
}
