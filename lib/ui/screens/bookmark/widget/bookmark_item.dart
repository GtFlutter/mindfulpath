import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';
import '../../../common/media_image_card.dart';
import '../../../common/outlined_icon_button.dart';
import '../../category/widget/detail_item.dart';

class BookmarkItem extends StatelessWidget {
  final AppStyle appStyle;
  final DIModel model;
  final String index;
  const BookmarkItem({super.key, required this.appStyle, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = appStyle.text.font(mulishRegular400, sizePx: 9);
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFF1B1B1B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appStyle.scaleX(10)),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: appStyle.scaleX(16),
        vertical: appStyle.scaleX(16),
      ),
      alignment: Alignment.center,
      child: IntrinsicHeight(
        child: Row(
          children: [
            MediaImageCard(
              appStyle: appStyle,
              imgUrl: model.imgUrl,
              duration: model.duration,
              imgRadius: appStyle.scaleX(10),
              imgSize: appStyle.scaleX(90),
            ),
            SizedBox(width: appStyle.scaleX(20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$index ${model.title}',
                    style: appStyle.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: appStyle.scaleX(12)),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: appStyle.scaleX(10),
                    children: [
                      Text(
                        model.auther,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle.copyWith(color: AppColors.autherNameColor),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '●',
                            style: appStyle.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: appStyle.scaleX(5)),
                          Flexible(
                            child: Text(
                              model.category,
                              style: textStyle.copyWith(color: AppColors.categoryNameColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),
                OutlinedIconButton.svg(
                  SvgPaths.bookmarkUnselected,
                  appStyle: appStyle,
                  // svgIconSrc: SvgPaths.bookmarkSelected,
                  onTap: () {},
                ),
                const Spacer(flex: 2),
                OutlinedIconButton.svg(
                  SvgPaths.addToPlaylist,
                  appStyle: appStyle,
                  onTap: () {},
                ),
                const Spacer(),
              ],
            ),
            SizedBox(width: appStyle.scaleX(10)),
          ],
        ),
      ),
    );
  }
}
