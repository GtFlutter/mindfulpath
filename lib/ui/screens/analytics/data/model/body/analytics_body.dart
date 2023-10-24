import 'package:flutter/material.dart';
import 'package:meditation_app/helper/date_converter.dart';

class AnalyticsBody {
  final int? categoryId;
  final int? videoId;
  final DateTimeRange duration;

  const AnalyticsBody({
    required this.categoryId,
    required this.videoId,
    required this.duration,
  });

  Map<String, dynamic> get toJson {
    Map<String, dynamic> body = {};
    if (categoryId != null) {
      body['category_id'] = categoryId;
    }
    if (categoryId != null && videoId != null) {
      body['video_id'] = videoId;
    }
    body['start_date'] = duration.start.toStringFormat3;
    body['end_date'] = duration.end.toStringFormat3;

    return body;
  }
}
