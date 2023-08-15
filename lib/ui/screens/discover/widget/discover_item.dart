import 'package:flutter/material.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';

class DBTempModel {
  final String title;
  final String subTitle;
  final String imgUrl;
  final String btnText;
  DBTempModel(this.title, this.subTitle, this.imgUrl, this.btnText);
}

class DiscoverItem extends StatelessWidget {
  final CategoryListResponse item;
  final AppStyle style;
  final VoidCallback? onPressed;

  const DiscoverItem({super.key, required this.item, required this.style, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      // aspectRatio: 325 / 178,
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage(item.imageResponse!.imageUrl ?? ''),
            fit: BoxFit.cover,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          gradient: const LinearGradient(
            colors: [AppColors.primaryGradientColor, AppColors.secondaryGradientColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            splashFactory: InkSplash.splashFactory,
            splashColor: Colors.white.withOpacity(0.2),
            onTap: onPressed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: style.scale * 23),
              width: double.infinity,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    item.title ?? '',
                    style: style.text.font(mulishBold700, sizePx: 20, color: AppColors.cardTextColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Text(
                  //   model.subTitle,
                  //   style: style.text.font(mulishRegular400, sizePx: 20, color: AppColors.cardTextColor),
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  const Spacer(),
                  FilledButton(
                    onPressed: onPressed,
                    style: FilledButton.styleFrom(
                      textStyle: style.text.font(
                        mulishSemiBold600,
                        sizePx: 12.5,
                        color: Colors.black,
                        spacingPc: 2.50,
                      ),
                      visualDensity: const VisualDensity(vertical: -1),
                    ),
                    child: Text(item.buttonTitle ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
