import 'package:flutter/material.dart';
import 'package:meditation_app/theme/styles.dart';

import '../../theme/colors.dart';
import '../../theme/text_style.dart';

class CustomNextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppStyle style;

  const CustomNextButton({super.key, required this.text, this.onPressed, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 500 * style.scale * 0.5),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.fieldButtonBgColor,
          textStyle: style.text.font(mulishBold700, sizePx: 15),
          padding: EdgeInsets.symmetric(vertical: style.scale * 10),
        ),
        child: Text(text),
      ),
    );
  }
}
