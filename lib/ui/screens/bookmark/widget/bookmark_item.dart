import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';
import '../../../common/media_image_card.dart';
import '../../category/widget/detail_item.dart';

class BookmarkItem extends StatelessWidget {
  final AppStyle appStyle;
  final DIModel model;
  final String index;
  final bool dragable;
  final bool dragging;

  const BookmarkItem({
    super.key,
    required this.appStyle,
    required this.model,
    required this.index,
  })  : dragable = false,
        dragging = false;

  const BookmarkItem.dragable({
    super.key,
    required this.appStyle,
    required this.model,
    required this.index,
    this.dragging = false,
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
              imgUrl: model.imgUrl,
              duration: model.duration,
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
                            '$index ${model.title} \n ashjsahd',
                            style: appStyle.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: appStyle.scaleX(5)),
                          Text.rich(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              text: model.auther,
                              style: textStyle.copyWith(color: AppColors.autherNameColor),
                              children: [
                                TextSpan(
                                  text: '  ● ',
                                  style:
                                      appStyle.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                                ),
                                TextSpan(
                                  text: model.category,
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
                            onPressed: () {},
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
                              fit: BoxFit.contain,
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
