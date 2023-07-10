import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/screens/shellnav/widget/custom_bottom_nav_item.dart';
import 'package:meditation_app/util/assets.dart';

class CustomBottomNa extends StatelessWidget {
  final AppStyle style;
  const CustomBottomNa({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    const BoxFit iconFit = BoxFit.fitHeight;
    double iconHeight = style.scaleX(24);

    /// [rawTopPadding] should be equal to [iconTopPadding]
    /// for good alignment
    double rowTopPadding = style.scaleX(5);
    double iconTopPadding = style.scaleX(5);

    /// [rawBottomPadding] should be equal to [iconBottomPadding]
    /// for good alignment
    double rowBottomPadding = style.scaleX(10);
    double iconBottomPadding = 0;

    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.only(
          left: style.scaleX(22),
          right: style.scaleX(22),
          bottom: style.scaleX(10),
        ),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: style.scaleX(0.5),
              color: AppColors.primaryColor,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(style.scaleX(40)),
          ),
        ),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: AppColors.bottomNavBgColor.withOpacity(0.69)),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: rowBottomPadding, top: rowTopPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomBottomNavItem(
                    icon: SvgPicture.asset(SvgPaths.libraryUnselected, height: iconHeight, fit: iconFit),
                    activeIcon: SvgPicture.asset(SvgPaths.librarySelected, height: iconHeight, fit: iconFit),
                    index: 0,
                    onTap: (int idx) => _onItemTapped(idx, context),
                    selectedIndex: _calculateSelectedIndex(context),
                    endPadding: iconBottomPadding,
                    startPadding: iconTopPadding,
                  ),
                  CustomBottomNavItem(
                    icon: SvgPicture.asset(SvgPaths.discoverUnselected, height: iconHeight, fit: iconFit),
                    activeIcon: SvgPicture.asset(SvgPaths.discoverSelected, height: iconHeight, fit: iconFit),
                    index: 1,
                    onTap: (int idx) => _onItemTapped(idx, context),
                    selectedIndex: _calculateSelectedIndex(context),
                    endPadding: iconBottomPadding,
                    startPadding: iconTopPadding,
                  ),
                  CustomBottomNavItem(
                    icon: SvgPicture.asset(SvgPaths.analyticsUnselected, height: iconHeight, fit: iconFit),
                    activeIcon: SvgPicture.asset(SvgPaths.analyticsSelected, height: iconHeight, fit: iconFit),
                    index: 2,
                    onTap: (int idx) => _onItemTapped(idx, context),
                    selectedIndex: _calculateSelectedIndex(context),
                    endPadding: iconBottomPadding,
                    startPadding: iconTopPadding,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location.startsWith(ScreenPaths.libraryScreen)) {
      return 0;
    }
    if (location.startsWith(ScreenPaths.discoverScreen)) {
      return 1;
    }
    if (location.startsWith(ScreenPaths.analyticsScreen)) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    final String location = GoRouterState.of(context).location;
    switch (index) {
      case 0:
        if (location != ScreenPaths.libraryScreen) {
          GoRouter.of(context).go(ScreenPaths.libraryScreen);
        }
        break;
      case 1:
        if (location != ScreenPaths.discoverScreen) {
          GoRouter.of(context).go(ScreenPaths.discoverScreen);
        }
        break;
      case 2:
        if (location != ScreenPaths.analyticsScreen) {
          GoRouter.of(context).go(ScreenPaths.analyticsScreen);
        }
        break;
    }
  }
}
