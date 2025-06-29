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
  // New list to hold flattened items
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await ref.read(freeAllItemProvider.notifier).fetchAllFreeItem(widget.category.id ?? 0); //fetch all pdfs data
      _createFlatItemList(); // Create the flattened list after data is loaded
      await initCall();
    });
  }

  static AppStyle _style = AppStyle();

  List<dynamic> _flatItems = [];

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

    // Check if category changed, if yes, fetch data again
    if (widget.category.id != oldWidget.category.id) {
      Future.delayed(Duration.zero, () async {
        await ref.read(freeAllItemProvider.notifier).fetchAllFreeItem(widget.category.id ?? 0);
        await initCall();
        _createFlatItemList();
      });
    }
  }


  void _createFlatItemList() {
    final allItemProvider = ref.read(freeAllItemProvider);
    List<dynamic> tempList = [];

    // 👇 Order: Video → Audio → PDF
    if (allItemProvider.allItemResponse != null) {
      tempList.addAll((allItemProvider.allItemResponse?.data?.video ??[]).map((video) => video));
    }

    if (allItemProvider.allItemResponse != null) {
      tempList.addAll((allItemProvider.allItemResponse?.data?.audio ??[]).map((audio) => audio));
    }

    if (allItemProvider.allItemResponse != null) {
      tempList.addAll((allItemProvider.allItemResponse?.data?.pdf ??[]).map((pdf) => pdf));
    }

    setState(() {
      _flatItems = tempList;
    });
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
      //Need to update other database data for all item list
    });
  }

  bool isAudioFile(String? url) {
    if (url == null) return false; // Or handle as you see fit

    final audioExtensions = ['.mp3', '.wav', '.aac', '.ogg', '.flac'];
    final uri = Uri.parse(url);
    final path = uri.path;
    final extension = path.substring(path.lastIndexOf('.')).toLowerCase();
    return audioExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    final downloadP = ref.watch(downloadProvider);
    final allItemProvider = ref.watch(freeAllItemProvider); // Get the provider state

    if (downloadP.complate == true) {
      refreshh();
      ref.read(downloadProvider.notifier).complate = false;
      setState(() {});
    }

    if (allItemProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // if (allItemProvider.allItemResponse == null || allItemProvider.allItemResponse!.list == null) {
    //   return const Center(child: Text('No data available.'));
    // }

    // final allItems = allItemProvider.allItemResponse!.list!; // No longer used

    if (_flatItems.isEmpty && !allItemProvider.loading) {
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
      itemCount: _flatItems.length,
      itemBuilder: (context, index) {
        final item = _flatItems[index];

        if (item is PdfResponse) {
          // It's a PDF
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
              isDownloaded: isDownloaded, // Implement logic
            ),
          );
        } else if (item is VideoResponse) {
          // It's a Video or Audio
          final isAudio = isAudioFile(item.videoUrl);
          bool isDownloaded = false;
          if (!isAudio) {
            isDownloaded = allItemProvider.downloadedVideo.any((element) {
              return item.id == int.parse(element.videoId ?? "0");
            });
          } else {
            isDownloaded = allItemProvider.downloadedAudio.any((element) {
              return item.id == int.parse(element.videoId ?? "0");
            });
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
              isDownloaded: isDownloaded, // Implement logic
            ),
          );
        } else {
          return const SizedBox.shrink(); // Should not happen, but handle it
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
        isAudioFile: false);
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
        isAudioFile: true);
  }

  Future<void> toggleItemBookmark(int? itemId, {bool isRemove = false, required bool isAudio}) async {
    if (itemId == null) return;
    await ref.read(bookmarkProvider).toggleBookmark(itemId, isRemove: isRemove, isAudio: isAudio);

    // Now handled by the provider: No need to call setState, as provider will update
  }

  @override
  bool get wantKeepAlive => true;
}

