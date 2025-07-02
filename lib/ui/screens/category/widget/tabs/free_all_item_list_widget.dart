import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/helper/navigation.dart';
import 'package:meditation_app/theme/styles.dart';

import '../../../../../data/model/all_item_data_model.dart';
import '../../../../../data/model/body/resource_type.dart';
import '../../../../../data/model/response/pdfs_response.dart';
import '../../../../../data/model/response/videos_response.dart';
import '../../../../../database/database_helper.dart';
import '../../../../../database/database_model.dart';
import '../../../../../provider/bookmark_provider.dart';
import '../../../../../provider/course_provider.dart';
import '../../../../../provider/download_provider.dart';
import '../../../../../provider/recent_videos_provider.dart';
import '../../../../../provider/resource_provider/free_all_item_list_provider.dart';
import '../../../../../provider/video_provider.dart';
import '../detail_item.dart';

class AllItemListWidget extends ConsumerStatefulWidget {
  final CategoryListResponse category;

  const AllItemListWidget({Key? key, required this.category}) : super(key: key);

  @override
  ConsumerState<AllItemListWidget> createState() => _AllItemListWidgetState();
}

class _AllItemListWidgetState extends ConsumerState<AllItemListWidget> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();

  static AppStyle _style = AppStyle();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await ref.read(freeAllItemProvider.notifier).fetchAllFreeItem(widget.category.id ?? 0);
      await initCall();
    });
  }

  Future<void> initCall() async {
    final provider = ref.read(freeAllItemProvider.notifier);
    final database = ref.read(databaseProvider);

    CategoryModal? res = await database.getSingleCategory(widget.category.id!.toString());
    provider.downloadedVideo = await database.getVideo(int.parse(res?.categoryId ?? "0"));

    CategoryModal? res1 = await database.getAudioSingleCategory(widget.category.id!.toString());
    provider.downloadedAudio = await database.getAudio(int.parse(res1?.categoryId ?? "0"));

    provider.downloadedPDF = await database.getPdf(widget.category.id!);
  }

  @override
  void didUpdateWidget(covariant AllItemListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.category.id != oldWidget.category.id) {
      Future.delayed(Duration.zero, () async {
        await ref.read(freeAllItemProvider.notifier).fetchAllFreeItem(widget.category.id ?? 0);
        await initCall();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> refreshh() async {
    Future.delayed(Duration.zero, () async {
      final coursePRead = ref.read(courseProvider);
      await coursePRead.getCategoryFromDatabase();
      await coursePRead.getAudioCategoryFromDatabase();
      await initCall();
    });
  }

  bool isAudioFile(String? url) {
    if (url == null) return false;
    final audioExtensions = ['.mp3', '.wav', '.aac', '.ogg', '.flac'];
    final uri = Uri.parse(url);
    final path = uri.path;
    final extension = path.substring(path.lastIndexOf('.')).toLowerCase();
    return audioExtensions.contains(extension);
  }

  List<dynamic> get flatItems {
    final allItemProvider = ref.watch(freeAllItemProvider);
    List<dynamic> tempList = [];

    if (allItemProvider.allItemResponse != null) {
      tempList.addAll((allItemProvider.allItemResponse?.data?.video ?? []));
      tempList.addAll((allItemProvider.allItemResponse?.data?.audio ?? []));
      tempList.addAll((allItemProvider.allItemResponse?.data?.pdf ?? []));
    }

    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));

    final downloadP = ref.watch(downloadProvider);
    final allItemProvider = ref.watch(freeAllItemProvider);

    if (downloadP.complate == true) {
      refreshh();
      ref.read(downloadProvider.notifier).complate = false;
    }

    if (allItemProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = flatItems;
    log("flat item--->${flatItems.length}");

    if (items.isEmpty && !allItemProvider.loading) {
      return const Center(child: Text('No data available.'));
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        log("pdf respose---${item is PdfResponse}");
        log("v or a respose---${item is VideoResponse}");
        if (item is PdfResponse) {
          final isDownloaded = allItemProvider.downloadedPDF.any((element) => element.pdfId == item.id.toString());
          return GestureDetector(
            onTap: () => viewPdf(item.pdfUrl),
            child: DetailItem.pdf(
              appStyle: _style,
              title: item.title ?? '',
              pdfModel: item,
              subTitle: item.categoryTitle ?? '',
              index: '$index',
              seletedItemId: item.id,
              isShow: true,
              isDownloaded: isDownloaded,
            ),
          );
        } else if (item is VideoResponse) {
          final isAudio = isAudioFile(item.videoUrl);
          bool isDownloaded = false;

          if (!isAudio) {
            isDownloaded = allItemProvider.downloadedVideo.any(
              (element) => item.id == int.parse(element.videoId ?? "0"),
            );
          } else {
            isDownloaded = allItemProvider.downloadedAudio.any(
              (element) => item.id == int.parse(element.videoId ?? "0"),
            );
          }

          return GestureDetector(
            onTap: () {
              if (!isAudio) {
                playVideo(item, index);
              } else {
                playAudio(item, index);
              }
            },
            child: DetailItem.video(
              appStyle: _style,
              isAudio: isAudio,
              model: item,
              index: '$index',
              seletedItemId: item.id,
              onToggleBookmark: () {
                toggleItemBookmark(item.id, isRemove: item.bookmarked ?? false, isAudio: isAudio);
              },
              isDownloaded: isDownloaded,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
    );
  }

  void viewPdf(String? pdfUrl) {
    if (pdfUrl == null) return;
    context.pushViewPDFScreen(pdfUrl);
  }

  void playVideo(VideoResponse model, int index) {
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
          index: index,
          isAudioFile: false,
        );
  }

  void playAudio(VideoResponse model, int index) {
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
          index: index,
          isAudioFile: true,
        );
  }

  Future<void> toggleItemBookmark(int? itemId, {bool isRemove = false, required bool isAudio}) async {
    if (itemId == null) return;
    await ref.read(bookmarkProvider).toggleBookmark(itemId, isRemove: isRemove, isAudio: isAudio);
  }

  @override
  bool get wantKeepAlive => true;
}
