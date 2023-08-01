import 'package:flutter/material.dart';
import 'package:meditation_app/theme/styles.dart';

import '../../theme/colors.dart';
import '../../theme/text_style.dart';

class CustomNextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppStyle style;
  final bool inProgress;

  const CustomNextButton({super.key, required this.text, this.onPressed, required this.style, this.inProgress = false});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 500 * style.scaleX(0.5)),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.fieldButtonBgColor,
                foregroundColor: inProgress ? Colors.black54 : null,
                textStyle: style.text.font(mulishBold700, sizePx: 15),
                padding: EdgeInsets.fromLTRB(
                  style.scaleX(inProgress ? 40 : 20),
                  style.scaleX(10),
                  style.scaleX(20),
                  style.scaleX(10),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(!inProgress ? text : 'Loading...'),
            ),
          ),
          if (inProgress)
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: style.scaleX(10)),
              constraints: BoxConstraints(maxHeight: style.scaleX(20), maxWidth: style.scaleX(20)),
              child: CircularProgressIndicator.adaptive(
                strokeWidth: style.scaleX(2),
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(Colors.green.shade900),
              ),
            ),
        ],
      ),
    );
  }
}
