import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/data/model/response/bookmark_list_response.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';
import '../../../common/media_image_card.dart';

class BookmarkItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    TextStyle textStyle = appStyle.text.font(mulishRegular400, sizePx: 9);
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFF1B1B1B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appStyle.scaleX(25)),
          side: BorderSide(
            color: AppColors.primaryColor,
            width: appStyle.scaleX(0.5),
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
      ),
      margin: dragable && !dragging ? EdgeInsets.only(bottom: appStyle.scaleX(12.5), top: appStyle.scaleX(12.5)) : null,
      padding: EdgeInsets.fromLTRB(
        appStyle.scaleX(29),
        appStyle.scaleX(31.5),
        appStyle.scaleX(29),
        appStyle.scaleX(21.5),
      ),
      alignment: Alignment.center,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaImageCard(
              appStyle: appStyle,
              imgUrl: model.bookmarkVideoResponse != null ? model.bookmarkVideoResponse!.thumbnailImageUrl ?? '' : '',
              duration: '10 Min',
              imgRadius: appStyle.scaleX(25),
              imgSize: appStyle.scaleX(90),
            ),
            Expanded(
              child: SizedBox(
                height: appStyle.scaleX(105),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: appStyle.scaleX(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${model.videoTitle}',
                            style: appStyle.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: appStyle.scaleX(5)),
                          Text.rich(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              style: textStyle.copyWith(color: AppColors.autherNameColor),
                              children: [
                                TextSpan(
                                  text: '  ● ',
                                  style:
                                      appStyle.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
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
                      padding: EdgeInsets.only(left: appStyle.scaleX(12.5)),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: onBookmarkRemove,
                            icon: SvgPicture.asset(
                              SvgPaths.remove,
                              height: appStyle.scaleX(16),
                              fit: BoxFit.contain,
                            ),
                            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              SvgPaths.share,
                              height: appStyle.scaleX(16),
                              fit: BoxFit.contain, // 155861
                            ),
                            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              SvgPaths.download,
                              height: appStyle.scaleX(16),
                              fit: BoxFit.contain,
                            ),
                            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (dragable)
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(SvgPaths.drag, width: appStyle.scaleX(15), fit: BoxFit.contain),
              ),
          ],
        ),
      ),
    );
  }
}
