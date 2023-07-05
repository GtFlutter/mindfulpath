import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/screens/shellnav/widget/bottom_nav_item.dart';
import 'package:meditation_app/util/assets.dart';

class BottomNav extends StatelessWidget {
  final AppStyle style;
  const BottomNav({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    const BoxFit iconFit = BoxFit.fitHeight;
    double iconHeight = style.scaleX(24);

    return Container(
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
      child: IntrinsicHeight(
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: AppColors.bottomNavBgColor.withOpacity(0.69),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomNavItem(icon: SvgPicture.asset(SvgPaths.libraryUnselected, height: iconHeight, fit: iconFit)),
                BottomNavItem(icon: SvgPicture.asset(SvgPaths.discoverSelected, height: iconHeight, fit: iconFit)),
                BottomNavItem(icon: SvgPicture.asset(SvgPaths.analyticsSelected, height: iconHeight, fit: iconFit)),
              ],
            ),
            // BottomNavigationBar(
            //   elevation: 0,
            //   backgroundColor: Colors.transparent,
            //   showSelectedLabels: false,
            //   landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            //   showUnselectedLabels: false,
            //   items: <BottomNavigationBarItem>[
            //     BottomNavigationBarItem(
            //       activeIcon: SvgPicture.asset(SvgPaths.librarySelected, height: iconHeight, fit: iconFit),
            //       icon: SvgPicture.asset(SvgPaths.libraryUnselected, height: iconHeight, fit: iconFit),
            //       label: ScreenPaths.libraryScreen,
            //       // label: ScreenPaths.libraryScreen,
            //     ),
            //     BottomNavigationBarItem(
            //       activeIcon: SvgPicture.asset(SvgPaths.discoverSelected, height: iconHeight, fit: iconFit),
            //       icon: SvgPicture.asset(SvgPaths.discoverUnselected, height: iconHeight, fit: iconFit),
            //       label: ScreenPaths.discoverScreen,
            //       // label: ScreenPaths.discoverScreen,
            //     ),
            //     BottomNavigationBarItem(
            //       activeIcon: SvgPicture.asset(SvgPaths.analyticsSelected, height: iconHeight, fit: iconFit),
            //       icon: SvgPicture.asset(SvgPaths.analyticsUnselected, height: iconHeight, fit: iconFit),
            //       label: ScreenPaths.analyticsScreen,
            //       // label: ScreenPaths.analyticsScreen,
            //     ),
            //   ],
            //   currentIndex: _calculateSelectedIndex(context),
            //   onTap: (int idx) => _onItemTapped(idx, context),
            // ),
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
