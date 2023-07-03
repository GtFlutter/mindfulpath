import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/theme/colors.dart';

import '../../main.dart';
import '../../theme/text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  final bool automaticallyImplyLeading;
  final Color? surfaceTintColor;
  final Size screenSize;
  final VoidCallback? onDonePressed;

  @override
  final Size preferredSize;

  CustomAppBar({
    super.key,
    this.title,
    this.automaticallyImplyLeading = true,
    this.surfaceTintColor,
    required this.screenSize,
    this.onDonePressed,
  }) : preferredSize = Size.fromHeight(kToolbarHeight + ($style.scale * screenSize.height < 800 ? 0.0 : 10));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.appBarBorderColor, width: $style.scale * 0.50),
                borderRadius: BorderRadius.circular($style.scale * 25),
              ),
              padding: EdgeInsets.symmetric(horizontal: $style.scale * 20, vertical: $style.scale * 6),
              child: Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis),
            )
          : null,
      centerTitle: true,
      automaticallyImplyLeading: false,
      surfaceTintColor: surfaceTintColor,
      leadingWidth: $style.scale * (30 + 30),
      leading: automaticallyImplyLeading
          ? IconButton.outlined(
              constraints: BoxConstraints(maxWidth: $style.scale * 30, maxHeight: $style.scale * 30),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
              iconSize: $style.scale * 15,
              style: IconButton.styleFrom(
                side: const BorderSide(color: AppColors.appBarBorderColor),
              ),
            )
          : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: $style.text.font(mulishSemiBold600, sizePx: 15, color: Colors.white),
      toolbarHeight: kToolbarHeight + ($style.scale * MediaQuery.of(context).size.height < 800 ? 0.0 : 28.5),
      actions: [
        if (onDonePressed != null)
          Padding(
            padding: EdgeInsets.only(right: $style.scale * 9),
            child: IconButton.outlined(
              constraints: BoxConstraints(maxWidth: $style.scale * 30, maxHeight: $style.scale * 30),
              onPressed: onDonePressed,
              icon: const Icon(Icons.done_rounded),
              iconSize: $style.scale * 15,
              style: IconButton.styleFrom(
                side: const BorderSide(color: AppColors.appBarBorderColor),
              ),
            ),
          ),
      ],
    );
  }
}
