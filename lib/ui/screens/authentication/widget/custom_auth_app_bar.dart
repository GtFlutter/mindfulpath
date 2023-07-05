import 'package:flutter/material.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';

class CustomAuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;
  final Color? surfaceTintColor;
  final double? leadingWidth;
  final Widget? leading;
  final Size screenSize;
  final AppStyle style;

  @override
  final Size preferredSize;

  CustomAuthAppBar({
    super.key,
    this.title,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    this.surfaceTintColor,
    this.leadingWidth,
    this.leading,
    required this.screenSize,
    required this.style,
  }) : preferredSize = Size.fromHeight(kToolbarHeight + (style.scale * screenSize.height < 800 ? 0.0 : 28.5));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      surfaceTintColor: surfaceTintColor,
      leadingWidth: leadingWidth,
      leading: leading,
      backgroundColor: Colors.transparent,
      // iconTheme: IconThemeData(color: AppColors.secondaryClr),
      elevation: 0,
      titleTextStyle: style.text.font(mulishMedium500, sizePx: 22.5),
      toolbarHeight: kToolbarHeight + (style.scale * MediaQuery.of(context).size.height < 800 ? 0.0 : 28.5),
    );
  }
}
