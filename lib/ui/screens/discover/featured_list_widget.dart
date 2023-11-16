import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/ui/common/paginated_list_view.dart';
import 'package:meditation_app/ui/screens/discover/widget/featured_item.dart';
import 'package:meditation_app/ui/screens/discover/widget/featured_item_painter.dart';

import '../../../provider/featured_videos_provider.dart';
import '../../../theme/styles.dart';

class FeaturedListWidget extends ConsumerStatefulWidget {
  const FeaturedListWidget({super.key, required this.style, required this.clipper});

  final AppStyle style;
  final DashboardCustomImageClipper clipper;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeaturedListWidgetState();
}

class _FeaturedListWidgetState extends ConsumerState<FeaturedListWidget> {
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
      return const Center(child: Text('Something Wenet Wrong'));
    }
    if (provider.data!.list!.isEmpty) {
      return const Center(child: Text('No Data Found'));
    }

    return SizedBox(
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
          itemView: SizedBox(
            height: 120 * widget.style.scale,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: scrollDirection,
              padding: EdgeInsets.symmetric(horizontal: widget.style.scale * 22),
              itemCount: provider.data!.list!.length,
              itemBuilder: (context, index) {
                return FeaturedItem(
                  provider.data!.list![index],
                  widget.clipper,
                  style: widget.style,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: widget.style.scale * 18);
              },
            ),
          ),
          onPaginate: (offset) async => await provider.getFeatureVideoList(offset, false),
        ),
      ),
    );
  }
}
