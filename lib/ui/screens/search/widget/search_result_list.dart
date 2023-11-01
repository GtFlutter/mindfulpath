import 'package:flutter/material.dart';
import 'package:meditation_app/data/model/response/video_list_response.dart';

import '../../../../theme/styles.dart';
import '../../category/widget/detail_item.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    super.key,
    required AppStyle style,
  }) : _style = style;

  final AppStyle _style;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 20,
      ),
      // itemCount: TempData.listDiModel.length,
      itemCount: 2,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: DetailItem(
            appStyle: _style,
            model: VideoListResponse(),
            index: '$index',
            onToggleBookmark: () {},
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: _style.scaleX(25),
      ),
    );
  }
}
