import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/model/body/resource_type.dart';
import '../../../../../data/model/response/videos_response.dart';
import '../../../../../provider/bookmark_provider.dart';
import '../../../../../provider/resource_provider/paid_videos_provider.dart';
import '../../../../../provider/video_provider.dart';
import '../../../../../theme/styles.dart';
import '../detail_item.dart';

class PaidVideoListWidget extends ConsumerStatefulWidget {
  final int categoryId;
  final String categoryTitle;

  const PaidVideoListWidget({super.key, required this.categoryTitle, required this.categoryId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaidVideoListWidgetState();
}

class _PaidVideoListWidgetState extends ConsumerState<PaidVideoListWidget> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    Future.delayed(Duration.zero, () => ref.read(paidVideosProvider).fetchVideos(widget.categoryId));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    var provider = ref.watch(paidVideosProvider);

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.videosResponse == null || provider.videosResponse!.list == null) {
      return const Center(child: Text('Unable to find data!'));
    }
    if (provider.videosResponse!.list!.isEmpty) {
      return const Center(child: Text('Paid Videos Is Empty'));
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 10,
      ),
      itemCount: provider.videosResponse!.list!.length,
      itemBuilder: (context, index) {
        var model = provider.videosResponse!.list![index];

        return GestureDetector(
          onTap: () => playVideo(model),
          child: DetailItem.video(
            appStyle: _style,
            model: model,
            index: '$index',
            onToggleBookmark: () => toggleItemBookmark(model.id),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
    );
  }

  void toggleItemBookmark(int? itemId) {
    if (itemId == null) return;
    ref.read(bookmarkProvider).toggleBookmark(itemId);
  }

  void playVideo(VideoResponse model) {
    ref.read(videoProvider).playVideo(
          DIModel(
            // imgUrl: model.thumbnailImage ?? '',
            imgUrl: model.videoUrl!,
            duration: model.duration ?? '',
            title: model.title ?? '',
            category: widget.categoryTitle,
            videoId: model.id!,
            videoType: model.videoType ?? ResourceType.paid,
          ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}
