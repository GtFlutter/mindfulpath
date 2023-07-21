import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/settings/widget/settings_listtile.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';
import '../../common/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static AppStyle _style = AppStyle();
  bool notification = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Settings',
        onDonePressed: () {},
      ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20), vertical: _style.scaleX(25)),
            child: Column(
              children: [
                SettingsListTile(
                  style: _style,
                  onPressed: () {},
                  tralling: Switch(
                    value: notification,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) {
                      setState(() {
                        notification = value;
                      });
                    },
                  ),
                  title: 'Notification',
                ),
                SizedBox(height: _style.scaleX(25)),
                SettingsListTile(
                  style: _style,
                  onPressed: () {},
                  tralling: SvgPicture.asset(SvgPaths.arrowRight, width: 20, fit: BoxFit.fitWidth),
                  title: 'Privacy Policy',
                ),
                SizedBox(height: _style.scaleX(25)),
                SettingsListTile(
                  style: _style,
                  onPressed: () {},
                  tralling: SvgPicture.asset(SvgPaths.arrowRight, width: 20, fit: BoxFit.fitWidth),
                  title: 'Terms & Conditions',
                ),
                SizedBox(height: _style.scaleX(25)),
                SettingsListTile(
                  style: _style,
                  onPressed: () {},
                  title: 'Share App',
                ),
                SizedBox(height: _style.scaleX(25)),
                SettingsListTile(
                  style: _style,
                  onPressed: () {},
                  title: 'Logout',
                ),
                SizedBox(height: _style.scaleX(25)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
