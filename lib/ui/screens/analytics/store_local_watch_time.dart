import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/model/response/analytics_result_model.dart';

class LocalAnalyticsStore {
  static const String _key = "local_analytics";

  /// Add watch time (in seconds) for given date/type/category/video
  static Future<void> addWatchTime({
    required bool isAudio,
    required int seconds,
    required DateTime date,
    int? categoryId,
    int? videoId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};

    // Load existing JSON
    final stored = prefs.getString(_key);
    if (stored != null) {
      data = jsonDecode(stored);
    }

    String typeKey = isAudio ? "audio" : "video";
    String dayKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    String categoryKey = categoryId?.toString() ?? "all";
    String videoKey = videoId?.toString() ?? "all";

    data.putIfAbsent(typeKey, () => {});
    data[typeKey].putIfAbsent(dayKey, () => {});
    data[typeKey][dayKey].putIfAbsent(categoryKey, () => {});
    data[typeKey][dayKey][categoryKey].putIfAbsent(videoKey, () => 0);

    data[typeKey][dayKey][categoryKey][videoKey] += seconds;

    await prefs.setString(_key, jsonEncode(data));
  }

  /// Read all watch time (returns the raw nested Map)
  static Future<Map<String, dynamic>> getAllWatchTime() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }
  static Future<AnalyticsResult> getOfflineWatchTime(
      DateTimeRange range, {
        bool isAudio = false,
      }) async {
    print(">>> getOfflineWatchTime CALLED (${isAudio ? 'AUDIO' : 'VIDEO'}) with ==> ${range.start} - ${range.end}");
    final data = await getAllWatchTime();
    print(">>> Data loaded from SharedPreferences ==> ${data.isEmpty ? 'EMPTY' : 'FOUND'}");

    final type = isAudio ? "audio" : "video";

    // Normalize range to full-day boundaries
    final startDate = DateTime(range.start.year, range.start.month, range.start.day);
    final endDate = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59);
    print(">>> Normalized range: $startDate - $endDate");

    final Map<String, int> dailyTotals = {};
    int totalSeconds = 0;

    if (data[type] != null) {
      final typeMap = data[type] as Map<String, dynamic>;
      for (final entry in typeMap.entries) {
        final dateStr = entry.key;
        final parsedDate = DateTime.tryParse(dateStr);
        if (parsedDate == null) continue;

        if (parsedDate.isBefore(startDate) || parsedDate.isAfter(endDate)) continue;

        final catMap = entry.value as Map<String, dynamic>;
        for (final catEntry in catMap.entries) {
          final contentMap = catEntry.value as Map<String, dynamic>;
          for (final itemEntry in contentMap.entries) {
            final sec = (itemEntry.value as num).toInt();
            totalSeconds += sec;
            dailyTotals[dateStr] = (dailyTotals[dateStr] ?? 0) + sec;
          }
        }
      }
    } else {
      print("⚠️ No '$type' key found in offline data");
    }

    print("✅ Processed $type section: ${dailyTotals.isEmpty ? 'No entries' : dailyTotals}");
    print("Total offline ${isAudio ? 'audio' : 'video'} watch time: $totalSeconds sec");

    // Convert totals to Statistic objects
    final statistics = dailyTotals.entries.map((e) {
      final d = DateTime.parse(e.key);
      return Statistic(
        playDate: e.key,
        totalDurationInSecond: e.value,
        month: d.month,
        monthName: _monthName(d.month),
        dayName: _dayName(d.weekday),
      );
    }).toList();

    // Build result
    return AnalyticsResult(
      statistics: statistics,
      totalWatchTimeHr: totalSeconds / 3600.0,
      totalWatchTime: formatDuration(totalSeconds),
      totalAvgWatchTimeHr:
      statistics.isEmpty ? 0 : (totalSeconds / statistics.length) / 3600.0,
      avgWatchTime: statistics.isEmpty
          ? "00h 00m 00s"
          : formatDuration(totalSeconds ~/ statistics.length),
      dayDiff: range.duration.inDays + 1,
    );
  }


  static String formatDuration(int totalSeconds) {
    final d = Duration(seconds: totalSeconds);
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(d.inHours)}h ${two(d.inMinutes % 60)}m ${two(d.inSeconds % 60)}s";
  }
  static String _monthName(int month) => [
    "Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"
  ][month - 1];

  static String _dayName(int weekday) => [
    "Mon","Tue","Wed","Thu","Fri","Sat","Sun"
  ][weekday - 1];
}
extension DurationFormat on int {
  String formatAsWatchTime() {
    final d = Duration(seconds: this);
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final secs = d.inSeconds.remainder(60);

    if (hours > 0) {
      return "${hours}h ${minutes}m ${secs}s";
    } else if (minutes > 0) {
      return "${minutes}m ${secs}s";
    } else {
      return "${secs}s";
    }
  }
}