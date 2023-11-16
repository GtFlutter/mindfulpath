import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../theme/text_style.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.style,
    required this.tabs,
  });

  final TabController tabController;
  final AppStyle style;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorPadding: EdgeInsets.symmetric(vertical: style.scaleX(9)),
      labelStyle: style.text.font(mulishRegular400, sizePx: 12.5),
      tabs: tabs,
    );
  }
}

class CustomTab extends StatelessWidget {
  final AppStyle style;
  final String text;

  const CustomTab({super.key, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.scaleX(40)),
          side: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: style.scaleX(12.5),
        vertical: style.scaleX(5),
      ),
      child: Text(text),
    );
  }
}
