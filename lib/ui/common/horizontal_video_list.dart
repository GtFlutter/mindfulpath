import 'package:flutter/material.dart';
import 'package:meditation_app/helper/navigation.dart';

import '../../data/model/body/resource_type.dart';
import '../../data/model/response/featured_videos_response.dart';
import '../../theme/styles.dart';
import '../screens/category/widget/detail_item.dart';
import '../screens/discover/widget/featured_item.dart';
import '../screens/discover/widget/featured_item_painter.dart';

class HorizontalVideoList extends StatelessWidget {
  final AppStyle style;
  final DashboardCustomImageClipper clipper;
  final List<FeaturedVideoResponse> list;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final ScrollController? controller;
  const HorizontalVideoList(
    this.list, {
    super.key,
    required this.style,
    required this.clipper,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120 * style.scale,
      child: ListView.separated(
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: style.scale * 22),
        itemCount: list.length,
        itemBuilder: (context, index) {
          var dataModel = list[index];
          return GestureDetector(
            onTap: () {
              if (dataModel.category != null) {
                context.goToDetailCategoryScreen(
                  dataModel.category!,
                  video: DIModel(
                    thumbnailUrl: dataModel.imgUrl ?? '',
                    videoType: ResourceType.paid,
                    videoId: dataModel.id!,
                    videoUrl: dataModel.videoUrl ?? '',
                    duration: dataModel.duration ?? '',
                    title: dataModel.title ?? 'Title Not Found',
                    categoryName: dataModel.category!.title ?? '',
                  ),
                );
              }
            },
            child: FeaturedItem(
              clipper,
              style: style,
              title: dataModel.title ?? '',
              imgUrl: dataModel.imgUrl ?? '',
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: style.scale * 18);
        },
      ),
    );
  }
}
