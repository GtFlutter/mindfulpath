enum FilterDuration {
  day(1),
  week(7),
  month(30),
  custome;

  final int? days;
  const FilterDuration([this.days]);
}
