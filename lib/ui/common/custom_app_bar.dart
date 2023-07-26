import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';

import '../../theme/text_style.dart';
import 'outlined_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  final bool automaticallyImplyLeading;
  final Color? surfaceTintColor;
  final Size screenSize;
  final VoidCallback? onDonePressed;
  final AppStyle style;

  @override
  final Size preferredSize;

  CustomAppBar({
    super.key,
    this.title,
    this.automaticallyImplyLeading = true,
    this.surfaceTintColor,
    required this.screenSize,
    this.onDonePressed,
    required this.style,
  }) : preferredSize = Size.fromHeight(kToolbarHeight + (style.scale * screenSize.height < 800 ? 0.0 : 10));

  @override
  Widget build(BuildContext context) {
    var borderWidth = style.scaleX(0.50);
    var borderColor = AppColors.appBarBorderColor;
    return AppBar(
      title: title != null
          ? Container(
              constraints: BoxConstraints(maxWidth: screenSize.shortestSide * 0.5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: borderWidth),
                borderRadius: BorderRadius.circular(style.scale * 25),
              ),
              padding: EdgeInsets.symmetric(horizontal: style.scale * 10, vertical: style.scale * 6),
              child: Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis),
            )
          : null,
      centerTitle: true,
      automaticallyImplyLeading: false,
      surfaceTintColor: surfaceTintColor,
      leadingWidth: style.scaleX((60)),
      leading: automaticallyImplyLeading
          ? IconButton.outlined(
              constraints: BoxConstraints(maxWidth: style.scaleX(40), maxHeight: style.scaleX(40)),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
              iconSize: style.scale * 15,
              style: IconButton.styleFrom(
                side: BorderSide(color: borderColor, width: borderWidth),
                padding: EdgeInsets.all(style.scaleX(10)),
              ),
            )
          : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: style.text.font(mulishSemiBold600, sizePx: 15, color: Colors.white),
      toolbarHeight: kToolbarHeight + (style.scale * MediaQuery.of(context).size.height < 800 ? 0.0 : 28.5),
      actions: [
        if (onDonePressed != null)
          Padding(
            padding: EdgeInsets.only(right: style.scale * 9),
            child: IconButton.outlined(
              constraints: BoxConstraints(maxWidth: style.scaleX(40), maxHeight: style.scaleX(40)),
              style: IconButton.styleFrom(
                side: BorderSide(color: borderColor, width: borderWidth),
                padding: EdgeInsets.all(style.scaleX(10)),
              ),
              onPressed: onDonePressed,
              icon: const Icon(Icons.done_rounded),
              iconSize: style.scale * 15,
            ),
          ),
      ],
    );
  }
}
