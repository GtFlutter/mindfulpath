import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/discover/widget/featured_item_painter.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';
import 'discover_list_widget.dart';
import 'featured_widget.dart';
import 'recent_list_widget.dart';
import 'widget/greeting.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    /// This is For Featured Card Image Clipper
    final DashboardCustomImageClipper clipper = DashboardCustomImageClipper(_style.scaleX(15));

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: _style.scale * 60,
        leading: Consumer(
          builder: (context, ref, child) {
            return IconButton(
              onPressed: () {
                if (ref.read(authProvider).isUserLoggedIn) {
                  context.go(RoutePath.profileScreenPath);
                } else {
                  context.push(RoutePath.signIn);
                }
              },
              icon: SvgPicture.asset(
                SvgPaths.profile,
                width: _style.scale * 20,
                fit: BoxFit.contain,
              ),
              style: IconButton.styleFrom(splashFactory: InkSplash.splashFactory),
            );
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: _style.scale * 9),
            child: IconButton(
              onPressed: () => context.push(RoutePath.featuredVideoScreen),
              icon: SvgPicture.asset(
                SvgPaths.search,
                width: _style.scale * 20,
                fit: BoxFit.contain,
              ),
              iconSize: _style.scale * 20,
            ),
          ),
        ],
        toolbarHeight: kToolbarHeight * _style.scale,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_style.scale * 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: _style.scale * 20, right: _style.scale * 22, bottom: _style.scale * 10),
              child: Greeting(key: const ValueKey('Greeting'), style: _style),
            ),
          ),
        ),
      ),
      body: BackgroundImage(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: _style.scale * 100, top: _style.scale * 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Discover Layout
                const DiscoverListWidget(),

                /// Featured Layout
                FeaturedWidget(style: _style, clipper: clipper),

                /// Recently played Layout
                RecentListWidget(style: _style, clipper: clipper),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
