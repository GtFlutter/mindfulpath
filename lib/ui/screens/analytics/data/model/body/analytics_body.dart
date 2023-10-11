import 'package:meditation_app/helper/date_converter.dart';

import '../../helper/analytics_enums.dart';

class AnalyticsBody {
  final int? categoryId;
  final int? videoId;
  final FilterDuration type;
  final DateTime startDate;
  final DateTime endDate;

  const AnalyticsBody({
    required this.type,
    required this.categoryId,
    required this.videoId,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> get toJson => {
        if (categoryId != null) "category_id": categoryId,
        if (videoId != null) "video_id": videoId,
        "start_date": startDate.toStringFormat3,
        "end_date": endDate.toStringFormat3,
      };
}
