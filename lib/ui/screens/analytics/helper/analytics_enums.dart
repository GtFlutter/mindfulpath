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
  downloadedVIDEO('Downloaded Video'),
  downloadedAUDIO('Downloaded Audio'),
  downloadedPDF('Downloaded Pdf'),
  currentlyProgress('Currently Progress');

  final String value;
  const ScreenTitles(this.value);

  static List<ScreenTitles> get toList => [purchased, downloadedVIDEO,downloadedAUDIO,downloadedPDF, currentlyProgress];
}
