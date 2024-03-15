import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/ui/common/paginated_list_view.dart';
import 'package:meditation_app/ui/screens/discover/widget/featured_item_painter.dart';

import '../../../provider/featured_videos_provider.dart';
import '../../../theme/styles.dart';
import '../../common/feature_video_list.dart';
import 'widget/discover_header.dart';

class FeaturedWidget extends ConsumerStatefulWidget {
  const FeaturedWidget({super.key, required this.style, required this.clipper});

  final AppStyle style;
  final DashboardCustomImageClipper clipper;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeaturedListWidgetState();
}

class _FeaturedListWidgetState extends ConsumerState<FeaturedWidget> {
  final ScrollController _scrollController = ScrollController();
  final Axis scrollDirection = Axis.horizontal;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () => ref.read(featuredVideosProvider).getFeatureVideoList(1, false),
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(featuredVideosProvider);
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.data == null || provider.data!.list == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(''),
        ),
      );
    }
    if (provider.data!.list!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DiscoverHeader(title: 'Featured', style: widget.style),
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            controller: _scrollController,
            scrollDirection: scrollDirection,
            child: PaginatedListView(
              scrollDirection: scrollDirection,
              scrollController: _scrollController,
              totalSize: provider.data!.total,
              offset: provider.data!.currentPage,
              itemView: FeatureVideoList.horizontal(
                key: const ValueKey<String>('rlw-hvl-1'),
                provider.data!.list!,
                style: widget.style,
                clipper: widget.clipper,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
              onPaginate: (offset) async => await provider.getFeatureVideoList(offset, false),
            ),
          ),
        ),
      ],
    );
  }
}
