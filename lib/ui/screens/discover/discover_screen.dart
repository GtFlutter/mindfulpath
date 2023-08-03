import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/discover/widget/discover_header.dart';
import 'package:meditation_app/ui/screens/discover/widget/featured_item.dart';
import 'package:meditation_app/ui/screens/discover/widget/featured_item_painter.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';
import 'discover_list_widget.dart';
import 'featured_list_widget.dart';

List<FCTempModel> featuredCardList = [
  FCTempModel(
    'Prevent Cancer',
    'https://images.pexels.com/photos/4151865/pexels-photo-4151865.jpeg?auto=compress&cs=tinysrgb&w=1920&h=1280&dpr=1',
  ),
  FCTempModel(
    'Flexibility & Mobility',
    'https://images.pexels.com/photos/6740518/pexels-photo-6740518.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  FCTempModel(
    'Superfoods & Health ',
    'https://images.pexels.com/photos/1034940/pexels-photo-1034940.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  FCTempModel(
    'Low-Carb Diets',
    'https://images.pexels.com/photos/841128/pexels-photo-841128.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  FCTempModel(
    'Transcendental Meditation',
    'https://images.pexels.com/photos/4553618/pexels-photo-4553618.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
];
List<FCTempModel> recentlyCardList = [
  FCTempModel(
    'Peaceful Presence',
    'https://images.pexels.com/photos/4151865/pexels-photo-4151865.jpeg?auto=compress&cs=tinysrgb&w=1920&h=1280&dpr=1',
  ),
  FCTempModel(
    'Workout Zone',
    'https://images.pexels.com/photos/6740518/pexels-photo-6740518.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  FCTempModel(
    'Superfoods & Health ',
    'https://images.pexels.com/photos/1034940/pexels-photo-1034940.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  FCTempModel(
    'Low-Carbs Diets',
    'https://images.pexels.com/photos/841128/pexels-photo-841128.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  FCTempModel(
    'Cancer Shield',
    'https://images.pexels.com/photos/4553618/pexels-photo-4553618.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
];

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        leading: IconButton(
          onPressed: () {
            if (ref.read(authProvider).isLoggedIn) {
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
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: _style.scale * 9),
            child: IconButton(
              onPressed: () {
                context.push(RoutePath.search);
              },
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
              child: Text(
                'Good morning',
                style: _style.text.font(mulishLight300, sizePx: 20, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
                DiscoverLayout(
                  style: _style,
                ),
                DiscoverHeader(title: 'Featured', style: _style),

                /// Featured Layout
                FeaturedListWidget(
                  style: _style,
                  clipper: clipper,
                  list: featuredCardList,
                ),

                DiscoverHeader(title: 'Recently played', style: _style),

                /// Recently played Layout

                FeaturedListWidget(
                  style: _style,
                  clipper: clipper,
                  list: recentlyCardList,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
