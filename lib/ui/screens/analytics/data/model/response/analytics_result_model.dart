import 'package:json_annotation/json_annotation.dart';

part 'analytics_result_model.g.dart';

// Map<String, dynamic> get value {
//   return {
//     "statistics_data": [
//       {
//         "play_date": "2023-10-10",
//         "total_duration_in_second": 20,
//         "month": 10,
//         "month_name": "Oct",
//         "day_name": "Tue",
//       }
//     ],
//     "total_watch_time_hr": 0.0055,
//     "total_watch_time": "00h 00m 20s",
//     "avg_watch_time": "00h 00m 20s",
//     "day_diff": 1
//   };
// }

enum ShowType { weekDayName, monthName, unknown }

@JsonSerializable(explicitToJson: false, createToJson: false)
class AnalyticsResult {
  @JsonKey(name: 'statistics_data')
  final List<Statistic> statistics;

  @JsonKey(name: 'total_watch_time_hr')
  final double? totalWatchTimeHr;
  @JsonKey(name: 'total_watch_time')
  final String? totalWatchTime;
  @JsonKey(name: 'avg_watch_time_hr')
  final double? totalAvgWatchTimeHr;
  @JsonKey(name: 'avg_watch_time')
  final String? avgWatchTime;
  @JsonKey(name: 'day_diff')
  final int? dayDiff;

  const AnalyticsResult({
    required this.statistics,
    required this.totalWatchTimeHr,
    required this.totalWatchTime,
    required this.totalAvgWatchTimeHr,
    required this.avgWatchTime,
    required this.dayDiff,
  });

  factory AnalyticsResult.fromJson(Map<String, dynamic> json) => _$AnalyticsResultFromJson(json);

  ShowType getShowType() {
    if (dayDiff == null) {
      return ShowType.unknown;
    } else if (dayDiff! > 7) {
      return ShowType.monthName;
    } else {
      return ShowType.weekDayName;
    }
  }
}

@JsonSerializable(explicitToJson: false, createToJson: false)
class Statistic {
  @JsonKey(name: 'play_date')
  final String playDate;
  @JsonKey(name: 'total_duration_in_second')
  final int totalDurationInSecond;
  final int month;
  @JsonKey(name: 'month_name')
  final String monthName;
  @JsonKey(name: 'day_name')
  final String dayName;

  const Statistic({
    required this.playDate,
    required this.totalDurationInSecond,
    required this.month,
    required this.monthName,
    required this.dayName,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) => _$StatisticFromJson(json);
}
