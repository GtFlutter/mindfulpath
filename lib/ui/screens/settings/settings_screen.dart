import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/provider/config_provider.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/settings/widget/custom_switch.dart';
import 'package:meditation_app/ui/screens/settings/widget/delete_account_dialog.dart';
import 'package:meditation_app/ui/screens/settings/widget/settings_listtile.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/model/response/static_data_model.dart';
import '../../../data/model/response/user_response.dart';
import '../../../provider/static_data_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../theme/styles.dart';
import '../../common/custom_app_bar.dart';
import 'widget/logout_dialog.dart';

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

    AsyncValue<UserResponse> user = ref.watch(getUserProfileProvider);
    AsyncValue<List<StaticData>> staticData = ref.watch(getStaticDataProvider);
    var configP = ref.watch(configProvider);

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
          // bottom: false,
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(getUserProfileProvider.future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20), vertical: _style.scaleX(25)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingsListTile(
                    style: _style,
                    onPressed: !user.hasValue || configP.isLoading ? null : () => configP.notificationToggle(),
                    tralling: user.when(
                      skipLoadingOnRefresh: false,
                      data: (data) {
                        if (configP.isLoading) {
                          return SizedBox(
                            height: _style.scaleX(22),
                            width: _style.scaleX(22),
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        return FlutterSwitch(
                          value: data.isNotificationMute == null ? false : data.isNotificationMute == 0,
                          width: _style.scaleX(35),
                          height: _style.scaleX(22),
                          borderRadius: _style.scaleX(20),
                          toggleSize: _style.scaleX(15),
                          activeToggleColor: const Color(0xFFEADDFF),
                          inactiveToggleColor: const Color(0xFF49454F),
                          inactiveSwitchBorder: Border.all(color: const Color(0xFF79747E), width: _style.scaleX(1.5)),
                          activeSwitchBorder: Border.all(color: const Color(0xFF5A5A5A), width: _style.scaleX(1.5)),
                          activeColor: const Color(0xFFB87A46),
                          inactiveColor: const Color(0xFFE6E0E9),
                          toggleMargin: _style.scaleX(4),
                          onToggle: (_) => configP.notificationToggle(),
                        );
                      },
                      error: (error, stackTrace) => IconButton(
                        onPressed: () => ref.refresh(getUserProfileProvider.future),
                        icon: const Icon(Icons.refresh_sharp),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                        ),
                      ),
                      loading: () => SizedBox(
                        height: _style.scaleX(22),
                        width: _style.scaleX(22),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    title: 'Notification',
                  ),
                  SizedBox(height: _style.scaleX(25)),
                  SettingsListTile(
                    style: _style,
                    onPressed: () => context.push(RoutePath.tCPpScreen, extra: false),
                    tralling: SvgPicture.asset(SvgPaths.arrowRight, width: 20, fit: BoxFit.fitWidth),
                    title: 'Privacy Policy',
                  ),
                  SizedBox(height: _style.scaleX(25)),
                  SettingsListTile(
                    style: _style,
                    onPressed: () => context.push(RoutePath.tCPpScreen, extra: true),
                    tralling: SvgPicture.asset(SvgPaths.arrowRight, width: 20, fit: BoxFit.fitWidth),
                    title: 'Terms & Conditions',
                  ),
                  SizedBox(height: _style.scaleX(25)),
                  staticData.when(
                    data: (data) {
                      int index = data.indexWhere(
                            (element) => element.key == (Platform.isAndroid ? 'share_android' : 'share_ios'),
                      );
                      return index != -1 && data[index].value != null
                          ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SettingsListTile(
                            style: _style,
                            onPressed: () {
                              Share.share(
                                'Download The ${AppConfigs.APP_NAME} App Now. \n ${data[index].value}',
                                subject: 'Download the ${AppConfigs.APP_NAME} app now.',
                              );
                            },
                            title: 'Share App',
                          ),
                          SizedBox(height: _style.scaleX(25)),
                        ],
                      )
                          : const SizedBox.shrink();
                    },
                    error: (_, __) => const SizedBox.shrink(),
                    loading: () => Column(
                      children: [
                        SettingsListTile(
                          style: _style,
                          onPressed: null,
                          title: 'Share App',
                          tralling: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        SizedBox(height: _style.scaleX(25)),
                      ],
                    ),
                  ),

                  // staticData.when(
                  //   data: (data) {
                  //     int index = data.indexWhere(
                  //       (element) => element.key == (Platform.isAndroid ? 'share_android' : 'share_ios'),
                  //     );
                  //     return index != -1 && data[index].value != null
                  //         ? Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               SettingsListTile(
                  //                 style: _style,
                  //                 onPressed: () {
                  //                   Share.share(
                  //                     'Download The ${AppConfigs.APP_NAME} App Now. \n ${data[index].value}',
                  //                     subject: 'Download the ${AppConfigs.APP_NAME} app now.',
                  //                   );
                  //                 },
                  //                 title: 'Share App',
                  //               ),
                  //               SizedBox(height: _style.scaleX(25)),
                  //             ],
                  //           )
                  //         : const SizedBox.shrink();
                  //   },
                  //   error: (Object _, StackTrace __) => const SizedBox.shrink(),
                  //   loading: () => const SizedBox.shrink(),
                  // ),
                  SettingsListTile(style: _style, onPressed: deleteAccount, title: 'Delete Account'),
                  SizedBox(height: _style.scaleX(25)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void deleteAccount() {
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
            child: DeleteAccountDialog(style),
          ),
        );
      },
    );
  }
}
