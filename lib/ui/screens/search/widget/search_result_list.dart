import 'package:flutter/material.dart';

import '../../../../theme/styles.dart';

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
        return const SizedBox.shrink();

        /// TODO : Workign On it
        // return GestureDetector(
        //   onTap: () {},
        //   child: DetailItem(
        //     appStyle: _style,
        //     model: VideoListResponse(),
        //     index: '$index',
        //     onToggleBookmark: () {},
        //   ),
        // );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: _style.scaleX(25),
      ),
    );
  }
}
