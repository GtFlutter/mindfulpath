import 'package:flutter/material.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';

class SettingsListTile extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? tralling;
  final String title;

  const SettingsListTile({
    super.key,
    required AppStyle style,
    this.onPressed,
    this.tralling,
    required this.title,
  }) : _style = style;

  final AppStyle _style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(
          _style.scaleX(25),
          _style.scaleX(15),
          _style.scaleX(15),
          _style.scaleX(15),
        ),
        decoration: ShapeDecoration(
          color: const Color(0xFF2D251F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_style.scaleX(10)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: _style.text.font(mulishSemiBold600, sizePx: 12.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (tralling != null) ...[
              SizedBox(width: _style.scaleX(10)),
              tralling!,
            ],
          ],
        ),
      ),
    );
  }
}
