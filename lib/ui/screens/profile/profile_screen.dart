import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/ui/screens/profile/widget/profile_item.dart';

import '../../../theme/styles.dart';
import '../../../util/assets.dart';
import '../../common/background_image.dart';
import '../../common/custom_app_bar.dart';

class PIModel {
  final String title;

  /// svg icon path
  final String src;

  /// Screen Path
  final String path;
  PIModel(this.title, this.src, this.path);
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static AppStyle _style = AppStyle();

  List<PIModel> list = [
    PIModel(
      'Edit Profile',
      SvgPaths.profileEdit,
      'path',
    ),
    PIModel(
      'Subscription',
      SvgPaths.subscription,
      'path',
    ),
    PIModel(
      'Notification',
      SvgPaths.notification,
      'path',
    ),
    PIModel(
      'Support',
      SvgPaths.support,
      'path',
    ),
    PIModel(
      'Settings',
      SvgPaths.settings,
      'path',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    const double ratio = 30;
    double maxWidth = _style.scaleX(16 * ratio);
    double maxHeight = _style.scaleX(8.2 * ratio);
    return Scaffold(
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Profile',
      ),
      extendBodyBehindAppBar: true,
      body: BackgroundImage(
        child: SafeArea(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: _style.scaleX(20),
              vertical: _style.scaleX(30),
            ),
            itemBuilder: (context, index) {
              return ProfileItem(
                title: list[index].title,
                src: list[index].src,
                appStyle: _style,
                onTap: () {
                  context.go(ScreenPaths.editProfileScreenPath);
                },
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: _style.scaleX(25));
            },
            itemCount: list.length,
          ),
        ),
      ),
    );
  }
}
