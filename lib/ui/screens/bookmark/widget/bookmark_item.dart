import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/data/model/response/bookmark_list_response.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';
import '../../../common/media_image_card.dart';

class BookmarkItem extends ConsumerStatefulWidget {
  final AppStyle appStyle;
  final BookmarkListResponse model;
  final String index;
  final bool dragable;
  final bool dragging;
  final GestureTapCallback? onBookmarkRemove;

  const BookmarkItem({
    super.key,
    required this.appStyle,
    required this.model,
    required this.index,
    required this.onBookmarkRemove,
  })  : dragable = false,
        dragging = false;

  const BookmarkItem.dragable({
    super.key,
    required this.appStyle,
    required this.model,
    required this.index,
    this.dragging = false,
    this.onBookmarkRemove,
  }) : dragable = true;

  @override
  ConsumerState<BookmarkItem> createState() => _BookmarkItemState();
}

class _BookmarkItemState extends ConsumerState<BookmarkItem> {


  @override
  void initState() {
    final downloadP = ref.read(downloadProvider);
    Future.delayed(Duration.zero, () {
      downloadP.checkVideoIsDownload(widget.model.bookmarkVideoResponse!.id.toString());
    },);
    super.initState();
  }

@override
  Widget build(BuildContext context) {
    TextStyle textStyle = widget.appStyle.text.font(mulishRegular400, sizePx: 9);
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFF1B1B1B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.appStyle.scaleX(25)),
          side: BorderSide(
            color: AppColors.primaryColor,
            width: widget.appStyle.scaleX(0.5),
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
      ),
      margin: widget.dragable && !widget.dragging ? EdgeInsets.only(bottom: widget.appStyle.scaleX(12.5), top: widget.appStyle.scaleX(12.5)) : null,
      padding: EdgeInsets.fromLTRB(
        widget.appStyle.scaleX(29),
        widget.appStyle.scaleX(31.5),
        widget.appStyle.scaleX(29),
        widget.appStyle.scaleX(21.5),
      ),
      alignment: Alignment.center,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaImageCard(
              appStyle: widget.appStyle,
              imgUrl: widget.model.bookmarkVideoResponse != null ? widget.model.bookmarkVideoResponse!.thumbnailImageUrlSrc ?? '' : '',
              duration: '10 Min',
              imgRadius: widget.appStyle.scaleX(25),
              imgSize: widget.appStyle.scaleX(90),
            ),
            Expanded(
              child: SizedBox(
                height: widget.appStyle.scaleX(105),
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
                                  style:
                                  widget.appStyle.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                                ),
                                TextSpan(
                                  text: 'Nutrition',
                                  style: textStyle.copyWith(color: AppColors.categoryNameColor),
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
                              height: widget.appStyle.scaleX(16),
                              fit: BoxFit.contain,
                            ),
                            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              SvgPaths.share,
                              height: widget.appStyle.scaleX(16),
                              fit: BoxFit.contain, // 155861
                            ),
                            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              final downloadP = ref.watch(downloadProvider);
                              if (downloadP.isAlreadyDownload) {
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
                                  return IconButton(
                                    onPressed: () {
                                      if (downloadP.model == null) {
                                        downloadP.download(model: widget.model.bookmarkVideoResponse);
                                      } else if (widget.model.bookmarkVideoResponse!.id != downloadP.model!.id) {
                                        showCustomSnackBar('Another Video is in progress');
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      SvgPaths.download,
                                      height: widget.appStyle.scaleX(16),
                                      fit: BoxFit.contain,
                                    ),
                                    style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                  );
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
            ),
            if (widget.dragable)
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(SvgPaths.drag, width: widget.appStyle.scaleX(15), fit: BoxFit.contain),
              ),
          ],
        ),
      ),
    );
  }
}
