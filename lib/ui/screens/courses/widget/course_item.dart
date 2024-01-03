import 'package:flutter/material.dart';

import '../../../../../theme/colors.dart';
import '../../../../../theme/styles.dart';
import '../../../../../theme/text_style.dart';

class CITempModel {
  final String title;
  final String imgUrl;

  CITempModel(this.title, this.imgUrl);
}

class CourseItem extends StatelessWidget {
  final CITempModel model;
  final AppStyle style;
  final VoidCallback? onPressed;

  const CourseItem({super.key, required this.model, required this.style, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16.0 / 8.2,
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage(model.imgUrl),
            fit: BoxFit.cover,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.scaleX(20))),
          gradient: const LinearGradient(
            colors: [AppColors.primaryGradientColor, AppColors.secondaryGradientColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(style.scaleX(20)),
            splashFactory: InkSplash.splashFactory,
            splashColor: Colors.white.withOpacity(0.2),
            onTap: onPressed,
            child: Container(
              padding: EdgeInsets.all(style.scaleX(15)),
              width: double.infinity,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.65),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.scaleX(15))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    model.title,
                    style: style.text.font(mulishBold700, sizePx: 15, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
