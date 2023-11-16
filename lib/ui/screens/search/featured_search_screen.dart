// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/search/widget/all_videos_list.dart';

import '../../../util/assets.dart';

class FeaturedSearchScreen extends ConsumerStatefulWidget {
  const FeaturedSearchScreen({super.key});

  @override
  ConsumerState<FeaturedSearchScreen> createState() => _FeaturedSearchScreenState();
}

class _FeaturedSearchScreenState extends ConsumerState<FeaturedSearchScreen> {
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    final dashboardNotifier = ref.read<DashboardNotifier>(dashboardProvider);
    Future.delayed(
      Duration.zero,
      () {
        /// TODO : Working On It
        // if (dashboardNotifier.featureVideoListResponse == null && dashboardNotifier.featureVideoListResponse!.isEmpty) {
        // dashboardNotifier.getFeatureVideoList();
        // }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    final dashboardNotifier = ref.watch<DashboardNotifier>(dashboardProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundImage(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: _style.scaleX(15)),
                  margin: EdgeInsets.symmetric(vertical: _style.scaleX(10)),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: Color(0xFF2D251F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_style.scaleX(22.5))),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        SvgPaths.search,
                        height: _style.scale * 20,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                      SizedBox(width: _style.scaleX(14)),
                      Flexible(
                        child: TextField(
                          readOnly: true,
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          onTap: () {
                            context.replace(RoutePath.search);
                          },
                          style: _style.text.font(mulishMedium500, sizePx: 11, color: Colors.white, spacingPc: 10),
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Hinted search text',
                            hintStyle:
                                _style.text.font(mulishMedium500, sizePx: 10, color: Colors.white.withOpacity(0.5)),
                            contentPadding: EdgeInsets.only(bottom: _style.scaleX(16)),
                            constraints: BoxConstraints(maxHeight: _style.scaleX(40)),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// TODO : WORKING ON IT
                // if (dashboardNotifier.isLoading) ...[
                //   Center(
                //     child: CircularProgressIndicator(),
                //   ),
                // ] else if (dashboardNotifier.featureVideoListResponse == null &&
                //     dashboardNotifier.featureVideoListResponse!.isEmpty) ...[
                //   Center(
                //     child: Text('No data found'),
                //   ),
                // ] else ...[
                //   Expanded(
                //       child: AllVideosList(
                //     style: _style,
                //     featureVideoListResponse: dashboardNotifier.featureVideoListResponse,
                //   ))
                // ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
