import 'package:flutter/material.dart';
import 'package:meditation_app/data/model/response/video_list_response.dart';
import 'package:meditation_app/ui/screens/discover/widget/featured_item.dart';
import 'package:meditation_app/ui/screens/discover/widget/featured_item_painter.dart';

import '../../../theme/styles.dart';

class FeaturedListWidget extends StatelessWidget {
  const FeaturedListWidget({
    super.key,
    required this.style,
    required this.clipper,
    required this.list,
  });

  final AppStyle style;
  final DashboardCustomImageClipper clipper;
  final List<VideoListResponse> list;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120 * style.scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: style.scale * 22),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return FeaturedItem(
            list[index],
            clipper,
            style: style,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: style.scale * 18);
        },
      ),
    );
  }
}
