import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/recent_videos_provider.dart';

import '../../../../../data/model/body/resource_type.dart';
import '../../../../../data/model/response/category_list_reponse.dart';
import '../../../../../data/model/response/videos_response.dart';
import '../../../../../database/database_helper.dart';
import '../../../../../database/database_model.dart';
import '../../../../../provider/bookmark_provider.dart';
import '../../../../../provider/resource_provider/free_videos_provider.dart';
import '../../../../../provider/video_provider.dart';
import '../../../../../theme/styles.dart';
import '../detail_item.dart';

class FreeVideoListWidget extends ConsumerStatefulWidget {
  final CategoryListResponse category;

  const FreeVideoListWidget({super.key, required this.category});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FreeVideoListWidgetState();
}

class _FreeVideoListWidgetState extends ConsumerState<FreeVideoListWidget>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ref.read(freeVideosProvider.notifier).fetchVideos(widget.category.id??0);
      await initCall();
    });

    super.initState();
  }

  Future<void> initCall() async {
    var provider = ref.read(freeVideosProvider);


    ///to get downloaded video for if already downloaded then hide button so....
    CategoryModal? res = await ref
        .read(databaseProvider)
        .getSingleCategory(widget.category.id!.toString());
    provider.downloadedVideo = await ref
        .read(databaseProvider)
        .getVideo(int.parse(res?.categoryId ?? "0"));
    print("category id---${widget.category.id}");
    print("getSingleCategory-------${res?.toJson()}");
    print("getSingleCategory-------***${provider.downloadedVideo}");
    if (provider.downloadedVideo.isNotEmpty) {
      print(
          "downloaded vedio----${provider.downloadedVideo.first.toJson()}---");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Future<void> refreshh() async{
    Future.delayed(Duration.zero, () async {
      final coursePRead = ref.read(courseProvider);
      await coursePRead.getCategoryFromDatabase();
      //for(final category in coursePWatch.downloadResponse){
       // await coursePRead.getVideoFromDatabase(int.parse(category.categoryId??""));
        await coursePRead.getVideoFromDatabase(widget.category.id??0);

    //  }
    });

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    var provider = ref.watch(freeVideosProvider);

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.videosResponse == null ||
        provider.videosResponse!.list == null) {
      return const Center(child: Text('Unable to find data!'));
    }
    if (provider.videosResponse!.list!.isEmpty) {
      return const Center(child: Text('Free Videos Is Empty'));
    }

    final downloadP = ref.watch(downloadProvider);

   // print('______-------video--------_____175_______${downloadP.isDownloading}');
    print('______-------video--------_____175_______${downloadP.complate}');
    if(downloadP.complate==true){
      refreshh();
      ref.read(downloadProvider.notifier).complate=false;
      setState((){});
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
        print('------**${model}');
//model.id==null?false:model.id == int.parse(provider.downloadedVideo[index].videoId??"0")
        //if(provider.downloadedVideo[index].videoId!=null){
        //  print('--135----****${provider.downloadedVideo[index].videoId??" "}');
        //}
        final isDownloaded=provider.downloadedVideo.any((element){
          return model.id==int.parse(provider.downloadedVideo[index].videoId??"0");
        } );


        provider.downloadedVideo.map((element) {
          print(
              "element.categoryId---${element.videoId}---${provider.videosResponse?.list?[index].id}");
          return element.id == provider.videosResponse?.list?[index].id;
        });
        return GestureDetector(
            onTap: () => playVideo(model),
            child: DetailItem.video(
              appStyle: _style,
              model: model,
              index: '$index',
              onToggleBookmark: () => toggleItemBookmark(model.video?.id,
                  isRemove: model.bookmarked ?? false),
              isDownloaded:isDownloaded ,
            ));
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: _style.scaleX(25)),
    );
  }

  void toggleItemBookmark(int? itemId, {bool isRemove = false}) {
    if (itemId == null) return;
    ref.read(bookmarkProvider).toggleBookmark(itemId, isRemove: isRemove);
  }

  void playVideo(VideoResponse model) {
    ref.read(videoProvider).playVideo(
          DetailedVideoModel(
            category: widget.category,
            video: DIModel(
              thumbnailUrl: model.imgUrl ?? '',
              videoUrl: model.videoUrl!,
              duration: model.duration ?? '',
              title: model.title ?? '',
              categoryName: widget.category.title ?? '',
              videoId: model.id!,
              videoType: model.videoType ?? ResourceType.paid,
            ),
          ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}
