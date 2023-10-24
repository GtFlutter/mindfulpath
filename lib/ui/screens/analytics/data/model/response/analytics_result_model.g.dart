// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsResult _$AnalyticsResultFromJson(Map<String, dynamic> json) =>
    AnalyticsResult(
      statistics: (json['statistics_data'] as List<dynamic>)
          .map((e) => Statistic.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalWatchTimeHr: (json['total_watch_time_hr'] as num?)?.toDouble(),
      totalWatchTime: json['total_watch_time'] as String?,
      avgWatchTime: json['avg_watch_time'] as String?,
      dayDiff: json['day_diff'] as int?,
    );

Statistic _$StatisticFromJson(Map<String, dynamic> json) => Statistic(
      playDate: json['play_date'] as String,
      totalDurationInSecond: json['total_duration_in_second'] as int,
      month: json['month'] as int,
      monthName: json['month_name'] as String,
      dayName: json['day_name'] as String,
    );
