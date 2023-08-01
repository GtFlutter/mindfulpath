import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/settings/widget/custom_switch.dart';
import 'package:meditation_app/ui/screens/settings/widget/settings_listtile.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';
import '../../common/custom_app_bar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
                  onPressed: () {
                    setState(() {
                      notification = !notification;
                    });
                  },
                  tralling: FlutterSwitch(
                    value: notification,
                    width: _style.scaleX(35),
                    height: _style.scaleX(22),
                    borderRadius: _style.scaleX(20),
                    toggleSize: _style.scaleX(15),
                    activeToggleColor: const Color(0xFFEADDFF),
                    inactiveToggleColor: const Color(0xFF49454F),
                    inactiveSwitchBorder: Border.all(color: const Color(0xFF79747E), width: _style.scaleX(1.5)),
                    activeSwitchBorder: Border.all(color: const Color(0xFF5A5A5A), width: _style.scaleX(1.5)),
                    activeColor: const Color(0xFF5A5A5A),
                    inactiveColor: const Color(0xFFE6E0E9),
                    onToggle: (value) {
                      setState(() {
                        notification = value;
                      });
                    },
                    toggleMargin: _style.scaleX(4),
                  ),
                  title: 'Notification',
                ),
                SizedBox(height: _style.scaleX(25)),
                SettingsListTile(
                  style: _style,
                  onPressed: () {
                    context.push(RoutePath.tCPpScreen, extra: false);
                  },
                  tralling: SvgPicture.asset(SvgPaths.arrowRight, width: 20, fit: BoxFit.fitWidth),
                  title: 'Privacy Policy',
                ),
                SizedBox(height: _style.scaleX(25)),
                SettingsListTile(
                  style: _style,
                  onPressed: () {
                    context.push(RoutePath.tCPpScreen, extra: true);
                  },
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
                  onPressed: logout,
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

  void logout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) {
        Size size = MediaQuery.of(c).size;
        AppStyle style = AppStyle(screenSize: size);
        return ProviderScope(
          parent: ProviderScope.containerOf(context),
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.scaleX(10))),
            child: LogoutDialog(style),
          ),
        );
      },
    );
  }
}

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog(this.style, {super.key});

  final AppStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authP = ref.watch(authProvider);
    return AbsorbPointer(
      absorbing: authP.isLoading,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: style.scaleX(330)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            style.scaleX(12.5),
            style.scaleX(26.5),
            style.scaleX(12.5),
            style.scaleX(18),
          ),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Log out',
                    style: style.text.font(mulishSemiBold600, sizePx: 20),
                  ),
                  SizedBox(height: style.scaleX(10)),
                  Text(
                    'Are you sure, you want to Logout?',
                    style: style.text.font(mulishRegular400, sizePx: 13),
                  ),
                  SizedBox(height: style.scaleX(37.5)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: authP.isLoading
                              ? null
                              : () {
                                  if (context.canPop()) {
                                    context.pop();
                                  }
                                },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            textStyle: style.text.font(mulishSemiBold600, sizePx: 15),
                            padding: EdgeInsets.symmetric(vertical: style.scaleX(10)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: style.scaleX(21)),
                      Expanded(
                        child: FilledButton(
                          onPressed: authP.isLoading
                              ? null
                              : () {
                                  authP.logoutUser();
                                },
                          style: FilledButton.styleFrom(
                            textStyle: style.text.font(mulishSemiBold600, sizePx: 15),
                            padding: EdgeInsets.symmetric(vertical: style.scaleX(10)),
                          ),
                          child: Text(authP.isLoading ? 'Loging out..' : 'Log out'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (authP.isLoading)
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: style.scaleX(10)),
                  constraints: BoxConstraints(maxHeight: style.scaleX(20), maxWidth: style.scaleX(20)),
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: style.scaleX(2),
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.green.shade900),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
