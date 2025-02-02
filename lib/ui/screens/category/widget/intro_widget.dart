import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';

class IntroWidget extends StatelessWidget {
  final String title;
  final AppStyle style;

  const IntroWidget({super.key, required this.title, required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: style.scaleX(15)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(flex: 3),
          Text(
            title,
            style: style.text.font(
              brandonMedium500,
              sizePx: 30,
              color: AppColors.primaryThemeColor1,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: style.scaleX(25)),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
