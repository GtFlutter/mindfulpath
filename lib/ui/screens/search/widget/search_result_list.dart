import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';

import '../../../../theme/styles.dart';

class SearchResultsList extends ConsumerWidget {
  const SearchResultsList({
    super.key,
    required AppStyle style,
    required List<VideoResponse> model
  }) : _style = style, _model = model;

  final AppStyle _style;
  final List<VideoResponse> _model;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 20,
      ),
      // itemCount: TempData.listDiModel.length,
      itemCount: _model.length,
      itemBuilder: (context, index) {
        // return const SizedBox.shrink();

        /// TODO : Workign On it
        return GestureDetector(
          onTap: () {},
          child: DetailItem.video(
            appStyle: _style,
            model: _model[index],
            index: '$index',
            onToggleBookmark: () => toggleItemBookmark(ref, _model[index].id, isRemove: _model[index].bookmarked ?? false),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: _style.scaleX(25),
      ),
    );
  }

  void toggleItemBookmark(WidgetRef ref, int? itemId, {bool isRemove = false}) {
    if (itemId == null) return;
    ref.read(bookmarkProvider).toggleBookmark(itemId, isRemove: isRemove);
  }
}
