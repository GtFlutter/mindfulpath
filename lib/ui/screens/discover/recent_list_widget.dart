import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/helper/navigation.dart';
import 'package:meditation_app/provider/recent_videos_provider.dart';
import 'package:meditation_app/ui/screens/discover/widget/featured_item_painter.dart';

import '../../../theme/styles.dart';
import 'widget/discover_header.dart';
import 'widget/featured_item.dart';

class RecentListWidget extends ConsumerStatefulWidget {
  const RecentListWidget({super.key, required this.style, required this.clipper});

  final AppStyle style;
  final DashboardCustomImageClipper clipper;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeaturedListWidgetState();
}

class _FeaturedListWidgetState extends ConsumerState<RecentListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(recentVideosProvider);

    if (provider.list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DiscoverHeader(title: 'Recently played', style: widget.style),
        SizedBox(
          height: 120 * widget.style.scale,
          child: ListView.separated(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: widget.style.scale * 22),
            itemCount: provider.list.length,
            itemBuilder: (context, index) {
              var dataModel = provider.list[index];
              return GestureDetector(
                onTap: () {
                  context.goToDetailCategoryScreen(dataModel.category, video: dataModel.video);
                },
                child: FeaturedItem(
                  widget.clipper,
                  style: widget.style,
                  title: dataModel.video.title,
                  imgUrl: dataModel.video.thumbnailUrl,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: widget.style.scale * 18);
            },
          ),
        )
      ],
    );
  }
}
