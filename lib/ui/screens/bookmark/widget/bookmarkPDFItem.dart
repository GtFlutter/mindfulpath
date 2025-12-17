import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/data/model/response/bookmark_list_response.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../data/model/body/resource_type.dart';
import '../../../../provider/bookmark_provider.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';
import '../../../common/media_image_card.dart';
import '../../settings/widget/logout_dialog.dart';

class BookmarkPDFItem extends ConsumerStatefulWidget {
  final AppStyle appStyle;
  final BookmarkPDFListResponse? model;
  final int index;
  final bool dragable;
  final String? url;
  final bool isAudio;
  final int? IsSelected;
  final bool dragging;
  final GestureTapCallback? onBookmarkRemove;
  final void Function()? onPlay;

  const BookmarkPDFItem({
    super.key,
    required this.appStyle,
    this.model,
    required this.isAudio,
    required this.index,
    required this.onBookmarkRemove,
    this.url,
    this.IsSelected,
    this.onPlay,
  })  : dragable = false,
        dragging = false;

  const BookmarkPDFItem.dragable({
    super.key,
    required this.appStyle,
    this.model,
    required this.index,
    required this.isAudio,
    this.url,
    this.onPlay,
    this.IsSelected,
    this.dragging = false,
    this.onBookmarkRemove,
  }) : dragable = true;

  @override
  ConsumerState<BookmarkPDFItem> createState() => _BookmarkItemState();
}

class _BookmarkItemState extends ConsumerState<BookmarkPDFItem> {
  bool result = true;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
          () {
        getCategory();
        getPDFDownload();

      },
    );
    super.initState();
  }

  @override
  void deactivate() {
    // ref.read(courseProvider.notifier).downloadPdfResponse.clear();
    // ref.read(courseProvider.notifier).downloadPdfResponses.clear();
  }
getCategory() async {
  final coursePRead = ref.read(courseProvider);
  final coursePWatch = ref.watch(courseProvider);
  for (final category in coursePWatch.downloadPdfResponse){
    await coursePRead.getPdfFromDatabase(category.categoryId ?? 0);
  }
}

  getPDFDownload() async {
    final downloadP = ref.read(downloadProvider);
    result = await downloadP.checkVideoIsDownload((widget.model?.bookmarkPdfResponse?.pdf ?? 0).toString(), true, false);
    log("result---->$result--->${widget.model?.bookmarkPdfResponse?.id}");
  }

  @override
  Widget build(BuildContext context) {
    final downloadP = ref.watch(downloadProvider);
    log("${widget.model?.bookmarkPdfResponse?.id} == ${downloadP.pdfModel?.id}");
    var vp = ref.watch(videoProvider);
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
                isPDF: true,
                appStyle: widget.appStyle,
                imgUrl: widget.model?.bookmarkPdfResponse != null ? widget.model?.bookmarkPdfResponse!.thumbnailImageUrlSrc ?? '' : '',
                duration: "",
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
                            '${widget.model?.pdfTitle ?? "Empty..."}',
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
                                  text: widget.model?.bookmarkPdfResponse?.category?.title ?? "",
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
                              // final downloadP = ref.watch(downloadProvider);
                              final getCat = ref.read(courseProvider).downloadPdfResponse.any((element) => int.parse(element.pdfId ?? "") == widget.model?.bookmarkPdfResponse?.id);

                              ref.watch(courseProvider).downloadPdfResponse.any((e) {
                                print('________))))))))))((((((((((4355(((${e.pdfId}');

                                return true;
                              });

                              if (getCat == true) {
                                return const SizedBox.shrink();
                              } else {
                                if (downloadP.isPdfDownloading && widget.model?.bookmarkPdfResponse!.id == downloadP.pdfModel!.id) {
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
                                        print('---------------------?${downloadP.pdfModel?.categoryId ?? 0}');
                                        print('------------widget.model?.bookmarkPdfResponse---------?${widget.model?.bookmarkPdfResponse?.toJson()}');
                                        if((widget.model?.bookmarkPdfResponse?.category?.isPurchased ?? false) || widget.model?.bookmarkPdfResponse?.pdfType==ResourceType.free){
                                          if (downloadP.pdfModel == null) {
                                            print(widget.model?.bookmarkPdfResponse?.categoryId ?? "");
                                            downloadP.pdfDownload(model: widget.model?.bookmarkPdfResponse);
                                          } else if (widget.model?.bookmarkPdfResponse?.id != downloadP.pdfModel!.id) {
                                            showCustomSnackBar('Another PDF is in progress');
                                          }
                                        }else{
                                          await buyNow(context, categoryId: (widget.model?.bookmarkPdfResponse?.categoryId ?? 0).toString(), amount:double.parse(widget.model?.bookmarkPdfResponse?.category?.price ?? "0.0"));
                                          ref.read(bookmarkProvider.notifier).getPDFBookmarks();

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
