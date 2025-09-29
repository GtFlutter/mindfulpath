import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/data/model/body/resource_type.dart';
import 'package:meditation_app/data/model/response/bookmark_list_response.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/settings/widget/logout_dialog.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../helper/route/route_paths.dart';
import '../../../../helper/route/router.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';
import '../../../common/media_image_card.dart';

class BookmarkItem extends ConsumerStatefulWidget {
  final AppStyle appStyle;
  final BookmarkListResponse model;
  final int index;
  final bool dragable;
  final String? url;
  final bool isAudio;
  final int? IsSelected;
  final bool dragging;
  final GestureTapCallback? onBookmarkRemove;
  final void Function() onPlay;

  const BookmarkItem({
    super.key,
    required this.appStyle,
    required this.model,
    required this.isAudio,
    required this.index,
    required this.onBookmarkRemove,
    this.url,
    this.IsSelected,
    required this.onPlay,
  })  : dragable = false,
        dragging = false;

  const BookmarkItem.dragable({
    super.key,
    required this.appStyle,
    required this.model,
    required this.index,
    required this.isAudio,
    this.url,
    required this.onPlay,
    this.IsSelected,
    this.dragging = false,
    this.onBookmarkRemove,
  }) : dragable = true;

  @override
  ConsumerState<BookmarkItem> createState() => _BookmarkItemState();
}

class _BookmarkItemState extends ConsumerState<BookmarkItem> {
  bool result = true;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        getDownload();
        getCategory();
        getAudioDownload();

      },
    );
    super.initState();
  }

  @override
  void deactivate() {
    ref.read(courseProvider.notifier).downloadResponse.clear();
    ref.read(courseProvider.notifier).downloadVideoResponse.clear();

    ref.read(courseProvider.notifier).downloadAudioResponse.clear();
  }

  getCategory() async {
    final coursePRead = ref.read(courseProvider);
    final coursePWatch = ref.watch(courseProvider);
    await coursePRead.getCategoryFromDatabase();
    await coursePRead.getAudioCategoryFromDatabase();
    for (final category in coursePWatch.downloadResponse) {
      await coursePRead.getVideoFromDatabase(int.parse(category.categoryId ?? ""));
    }
    for (final category in coursePWatch.downloadAudioCategoryResponse) {
      await coursePRead.getAudioFromDatabase(int.parse(category.categoryId ?? ""));
    }
  }

  getDownload() async {
    final downloadP = ref.read(downloadProvider);
    result = await downloadP.checkVideoIsDownload((widget.model.bookmarkVideoResponse?.id ?? 0).toString(), false, false);
  }

  getAudioDownload() async {
    final downloadP = ref.read(downloadProvider);
    result = await downloadP.checkVideoIsDownload((widget.model.bookmarkVideoResponse?.id ?? 0).toString(), false, true);
  }

  @override
  Widget build(BuildContext context) {
    var vp = ref.watch(videoProvider);
    TextStyle textStyle = widget.appStyle.text.font(mulishRegular400, sizePx: 9);
    String timeStr = widget.model.bookmarkVideoResponse?.duration ?? "";
    List<String> timeComponents = timeStr.split(":");
    int minute = 0;
    int second = 0;
    if (timeComponents.isNotEmpty && timeComponents.length > 1) {
      minute = int.parse(timeComponents[1]);
      second = int.parse(timeComponents[2].split(".")[0]);
    } // Extract only seconds
    print("Minute: $minute, Second: $second");

//primaryColor
    return GestureDetector(
      onTap: () {
        widget.onPlay();
      },
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFF1B1B1B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.appStyle.scaleX(25)),
            side: BorderSide(
              color: (vp.isSelected == widget.index) ? AppColors.primaryColor : AppColors.detailItemBgColor,
              width: widget.appStyle.scaleX(0.5),
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
        ),
        margin: widget.dragable && !widget.dragging ? EdgeInsets.only(bottom: widget.appStyle.scaleX(12.5), top: widget.appStyle.scaleX(12.5)) : null,
        padding: EdgeInsets.fromLTRB(
          widget.appStyle.scaleX(15),
          widget.appStyle.scaleX(15),
          widget.appStyle.scaleX(15),
          widget.appStyle.scaleX(15),
          // widget.appStyle.scaleX(29),
          // widget.appStyle.scaleX(30.5),
          // widget.appStyle.scaleX(29),
          // widget.appStyle.scaleX(14.5),
        ),
        alignment: Alignment.center,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediaImageCard(
                appStyle: widget.appStyle,
                imgUrl: widget.model.bookmarkVideoResponse != null ? widget.model.bookmarkVideoResponse!.thumbnailImageUrlSrc ?? '' : '',
                duration: minute == 0 ? '${second} Sec' : '${minute} Min',
                imgRadius: widget.appStyle.scaleX(25),
                imgSize: widget.appStyle.scaleX(90),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: widget.appStyle.scaleX(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.model.videoTitle}',
                            style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: widget.appStyle.scaleX(5)),
                          Text.rich(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              style: textStyle.copyWith(color: AppColors.autherNameColor),
                              children: [
                                TextSpan(
                                  text: '  ● ',
                                  style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 16, color: AppColors.primaryColor),
                                ),
                                TextSpan(
                                  text: widget.model.bookmarkVideoResponse?.category?.title ?? "",
                                  style: textStyle.copyWith(color: AppColors.categoryNameColor, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(left: widget.appStyle.scaleX(12.5)),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: widget.onBookmarkRemove,
                            icon: SvgPicture.asset(
                              SvgPaths.remove,
                              height: widget.appStyle.scaleX(18),
                              fit: BoxFit.contain,
                            ),
                            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          ),
                          IconButton(
                            onPressed: () {
                              Share.share(
                                widget.url ?? "",
                              );
                            },
                            icon: SvgPicture.asset(
                              SvgPaths.share,
                              height: widget.appStyle.scaleX(18),
                              fit: BoxFit.contain, // 155861
                            ),
                            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              final downloadP = ref.watch(downloadProvider);
                              final coursePWatch = ref.watch(courseProvider);
                              bool getCat = false;
                              if (widget.isAudio) {
                                getCat = ref.read(courseProvider).downloadAudioResponse.any((element) {
                                  log("audio bookmark download--->${element.videoId}~~~~~${widget.model.bookmarkVideoResponse?.id}");
                                  return int.parse(element.videoId ?? "") == widget.model.bookmarkVideoResponse?.id;
                                });
                                log("getcat-----1 $getCat");
                              } else {
                                getCat = ref.read(courseProvider).downloadVideoResponse.any((element) => int.parse(element.videoId ?? "") == widget.model.bookmarkVideoResponse?.video?.id);
                                log("getcat-----2 $getCat");
                              }

                              if (getCat == true) {
                                return const SizedBox.shrink();
                              } else {
                                if (downloadP.isDownloading && widget.model.bookmarkVideoResponse!.id == downloadP.model!.id) {
                                  return SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeCap: StrokeCap.butt,
                                      strokeWidth: 2,
                                      value: downloadP.progress,
                                    ),
                                  );
                                } else {
                                  if (!result) {
                                    return IconButton(
                                      onPressed: () async {
                                        if((widget.model.bookmarkVideoResponse?.category?.isPurchased ?? false) || widget.model.bookmarkVideoResponse?.videoType==ResourceType.free){
                                          if (downloadP.model == null) {
                                            if (widget.isAudio) {
                                              downloadP.downloadAudio(model: widget.model.bookmarkVideoResponse);
                                            } else {
                                              downloadP.download(model: widget.model.bookmarkVideoResponse);
                                            }
                                          } else {
                                            if (widget.model.bookmarkVideoResponse!.id != downloadP.model!.id) {
                                              if (widget.model.bookmarkVideoResponse?.video != null) {
                                                showCustomSnackBar('Another Video is in progress');
                                              } else {
                                                showCustomSnackBar('Another Audio is in progress');
                                              }
                                            }
                                          }
                                        }else{
                                          await buyNow(context, categoryId: widget.model.bookmarkVideoResponse!.categoryId.toString());
                                          ref.read(bookmarkProvider.notifier).getBookmarkList();
                                          ref.read(bookmarkProvider.notifier).getAudioBookmarks();

                                        }

                                      },
                                      icon: SvgPicture.asset(
                                        SvgPaths.download,
                                        height: widget.appStyle.scaleX(18),
                                        fit: BoxFit.contain,
                                      ),
                                      style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.dragable)
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(SvgPaths.drag, width: widget.appStyle.scaleX(15), fit: BoxFit.contain),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
