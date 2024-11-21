import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/data/model/response/playlist_details_response.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/common/media_image_card.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';

class SubPlayListItem extends ConsumerStatefulWidget {
  final AppStyle appStyle;
  final PlaylistVideoList model;
  final int index;
  final bool dragable;
  final bool isAudio;
  final String? url;
  final bool dragging;
  final GestureTapCallback? onBookmarkRemove;
  final void Function()? onPlay;
  final void Function()? onRemovePress;

  const SubPlayListItem({
    super.key,
    required this.appStyle,
    required this.model,
    required this.isAudio,
    required this.index,
    this.onBookmarkRemove,
    this.onPlay,
    this.onRemovePress,
    this.url,
  })  : dragable = false,
        dragging = false;

  @override
  ConsumerState<SubPlayListItem> createState() => _SubPlayListItemState();
}

class _SubPlayListItemState extends ConsumerState<SubPlayListItem> {
  bool result = true;
  VideoResponse? model;

  @override
  void initState() {
    model = widget.model.video!;

    Future.delayed(
      Duration.zero,
      () {
        // downloadP.checkVideoIsDownload(widget.model.videoId.toString(), false);
        getDownload();
        getAudioDownload();
        getCategory();
      },
    );
    super.initState();
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

  @override
  void deactivate() {
    ref.read(courseProvider.notifier).downloadPdfResponses.clear();
    ref.read(courseProvider.notifier).downloadResponse.clear();
    ref.read(courseProvider.notifier).downloadAudioCategoryResponse.clear();
  }

  getDownload() async {
    final downloadP = ref.read(downloadProvider);
    // log("video id in playlist----${widget.isAudio ? widget.model.audio!.id : widget.model.video!.id}");
    // result = await downloadP.checkVideoIsDownload(widget.model.video!.id.toString(), false);
    if (model != null) {
      result = await downloadP.checkVideoIsDownload(model!.id.toString(), false, false);
    }
  }

  getAudioDownload() async {
    final downloadP = ref.read(downloadProvider);
    if (model != null) {
      result = await downloadP.checkVideoIsDownload(model!.id.toString(), false, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = widget.appStyle.text.font(mulishRegular400, sizePx: 9);

    return GestureDetector(
      onTap: () {
        widget.onPlay!();
      },
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFF1B1B1B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.appStyle.scaleX(25)),
            side: BorderSide(
              color: (ref.watch(videoProvider).isSelected == widget.index) ? AppColors.primaryColor : AppColors.detailItemBgColor,
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
        ),
        alignment: Alignment.center,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: (context) {
                debugPrint("Nothing asncajksnc ${model!.thumbnailImageUrlSrc}");
                return MediaImageCard(
                  appStyle: widget.appStyle,
                  imgUrl: model!.thumbnailImageUrlSrc!,
                  duration: (widget.model.video?.duration ?? "").toDuration,
                  imgRadius: widget.appStyle.scaleX(25),
                  imgSize: widget.appStyle.scaleX(100),
                );
              }),
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
                            '${model!.title}',
                            style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: widget.appStyle.scaleX(5)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  style: textStyle.copyWith(color: AppColors.autherNameColor),
                                  children: [
                                    TextSpan(
                                      text: '  ● ',
                                      style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                                    ),
                                    TextSpan(
                                      text: model!.categoryTitle,
                                      style: textStyle.copyWith(color: AppColors.categoryNameColor, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: widget.appStyle.scaleX(12.5)),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              widget.onRemovePress!();
                            },
                            icon: SvgPicture.asset(
                              SvgPaths.remove,
                              height: 17,
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
                              // final getCat = ref.read(courseProvider).downloadVideoResponse.any((element) => int.parse(element.videoId ?? "") == widget.model.video?.id);
                              bool getCat = false;
                              if (widget.isAudio) {
                                getCat = ref.read(courseProvider.notifier).downloadAudioResponse.any((element) {
                                  log("audio playlist download--->${element.videoId}~~~~~${widget.model.toJson()}");
                                  return int.parse(element.videoId ?? "") == widget.model.video?.id;
                                });
                                log("getcat in sub playlist item-----1 $getCat");
                              } else {
                                getCat = ref.read(courseProvider.notifier).downloadVideoResponse.any((element) => int.parse(element.videoId ?? "") == widget.model.video?.video?.id);
                                log("getcat sub playlist item-----2 $getCat");
                              }
                              if (getCat) {
                                return const SizedBox.shrink();
                              } else {
                                // if (downloadP.isDownloading && bookmarkNotifier.bookmarkListResponse?[widget.index].bookmarkVideoResponse!.id == downloadP.model!.id) {
                                if (downloadP.isDownloading && widget.model.video?.id == downloadP.model!.id) {
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
                                        if (downloadP.model == null) {
                                          if (widget.isAudio) {
                                            downloadP.downloadAudio(model: widget.model.video);
                                          } else {
                                            downloadP.download(model: widget.model.video);
                                          }
                                        } else {
                                          if (widget.model.video!.id != downloadP.model!.id) {
                                            if (widget.model.video?.video != null) {
                                              showCustomSnackBar('Another Video is in progress');
                                            } else {
                                              showCustomSnackBar('Another Audio is in progress');
                                            }
                                          }
                                        }
                                        // if (downloadP.model == null) {
                                        //   downloadP.download(model: widget.model.video);
                                        // } else if (widget.model.video!.id != downloadP.model!.id) {
                                        //   showCustomSnackBar('Another Video is in progress');
                                        // }
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
