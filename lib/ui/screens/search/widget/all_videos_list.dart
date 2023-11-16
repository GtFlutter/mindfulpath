import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/video_list_response.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';

import '../../../../theme/styles.dart';
import '../../category/widget/detail_item.dart';

class AllVideosList extends StatelessWidget {
  const AllVideosList({
    super.key,
    required AppStyle style,
    required this.featureVideoListResponse,
  }) : _style = style;

  final AppStyle _style;
  final List<VideoListResponse>? featureVideoListResponse;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 20,
      ),
      itemCount: featureVideoListResponse!.length > 4 ? featureVideoListResponse!.length : 3,
      itemBuilder: (context, index) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return SizedBox.shrink();

            /// TODO : Working On It
            // return GestureDetector(
            //   onTap: () {},
            //   child: DetailItem(
            //     appStyle: _style,
            //     model: featureVideoListResponse![index],
            //     index: '$index',
            //     onToggleBookmark: () {
            //       if(featureVideoListResponse![index].videResponse==null) return;
            //       ref.read(bookmarkProvider).toggleBookmark(featureVideoListResponse![index].id!);
            //     },
            //   ),
            // );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: _style.scaleX(25),
      ),
    );
  }
}
