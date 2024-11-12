import 'package:flutter/material.dart';
import 'package:meditation_app/helper/date_converter.dart';

class AnalyticsBody {
  final int? categoryId;
  final int? videoId;
  final bool isAudio;
  final DateTimeRange duration;
  final AnalyticsType? selectedType;

  const AnalyticsBody({
    required this.categoryId,
    required this.videoId,
    required this.isAudio,
    required this.duration,
    this.selectedType,
  });

  Map<String, dynamic> get toJson {
    Map<String, dynamic> body = {};
    if (categoryId != null) {
      body['category_id'] = categoryId;
    }
    if (categoryId != null && videoId != null) {
      body[isAudio ? 'audio_id' : 'video_id'] = videoId;
    }
    if(selectedType != null){
      body['selected_type'] = selectedType!.value;
    }
    body['start_date'] = duration.start.toStringFormat3;
    body['end_date'] = duration.end.toStringFormat3;

    return body;
  }
}

enum AnalyticsType{

  audio('audio'),
  video('video');

  final String value;
  const AnalyticsType(this.value);

}