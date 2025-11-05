import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/helper/date_converter.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/response/category_and_video_name_model.dart';
import 'package:meditation_app/ui/screens/analytics/data/provider/analytics_provider.dart';
import 'package:meditation_app/ui/screens/analytics/helper/analytics_enums.dart';
import 'package:meditation_app/ui/screens/analytics/helper/analytics_extensions.dart';
import 'package:meditation_app/ui/screens/analytics/ui/widget/analytics_chart.dart';
import 'package:meditation_app/ui/screens/analytics/ui/widget/analytics_details.dart';

import '../../../../provider/auth_provider.dart';
import '../../../../provider/resource_provider/internet_provider.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../common/background_image.dart';
import '../../../common/custom_app_bar.dart';
import '../../../common/no_internet_screen.dart';
import '../../../common/sign_in_require.dart';
import 'widget/analytics_filter.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  static AppStyle _style = AppStyle();

  ItemName? selectedItem;
  List<ItemName> listVideoAudio = [ItemName(id: 0, title: 'Videos'), ItemName(id: 1, title: 'Audios')];

  @override
  void initState() {
    ref.read(analyticsProvider).initData(notifie: false);
    selectedItem = listVideoAudio.first;
    if (ref.read(authProvider).isUserLoggedIn) {
      Future.delayed(
        Duration.zero,
        () {
          ref.read(analyticsProvider).getCategoryNamesList(selectedItem == ItemName(id: 1, title: 'Audios'));
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var orientation = MediaQuery.orientationOf(context);
    final hasInternet = ref.watch(internetProvider);

    final notifier = ref.read(internetProvider.notifier);
    _style = AppStyle(screenSize: size);

    var prov = ref.watch(analyticsProvider);

    log("---------->watch time----->${prov.reslut?.totalWatchTimeHr}");

    TextStyle textStyle = _style.text.font(mulishMedium500, sizePx: 12.5);
    TextStyle subTextStyle = _style.text.font(mulishRegular400, sizePx: 10);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Analytics',
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: prov.loading
                ? null
                : () {
                    setState(() {
                      selectedItem = listVideoAudio.first; // Reset to 'Videos'
                    });
                    // prov.reset(false);
                    prov.reset(selectedItem == ItemName(id: 1, title: 'Audios'));
                  },
            child: const Text('Reset'),
          ),
        ],
      ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Builder(builder: (context) {
            if (!ref.read(authProvider).isUserLoggedIn) {
              return const SignInRequire();
            }

            String resultOf = '${prov.duration.start.toStringFormat3}${prov.durationtype != FilterDuration.day ? ' To ${prov.duration.end.toStringFormat3}' : ''}';

            return hasInternet
                ? Column(
                    children: [
                      AbsorbPointer(
                        absorbing: prov.loading,
                        child: AnalyticsFilter(
                          _style,
                          size,
                          categoryValue: prov.categoryId,
                          videoValue: prov.videoId,
                          selectedItem: selectedItem,
                          durationtypeValue: prov.durationtype,
                          categories: prov.categories,
                          videos: listVideoAudio,
                          durationtypes: FilterDuration.toList(),
                          onCategoryChanged: (value) => prov.onCategoryChanged(value, isAudio: selectedItem?.id == 1),
                          onVideoChanged: (value) {
                            selectedItem = value;
                            if (value == listVideoAudio.first) {
                              prov.getAnalytics(false);
                            } else {
                              prov.getAnalytics(true);
                            }
                            setState(() {});
                          },
                          onDurationTypeChanged: (value) => prov.onDurationTypeChanged(value, selectedItem?.id == 1),
                        ),
                      ),
                      if (prov.loading)
                        const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (prov.reslut == null || prov.reslut!.statistics.isEmpty)
                        // else if (prov.reslut == null)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (prov.reslut == null) ...[
                                  TextButton(
                                      onPressed: () {
                                        prov.getAnalytics(selectedItem?.id == 1);
                                      },
                                      child: Text("Retry")),
                                ] else ...[
                                  Text(
                                    prov.reslut == null ? 'Something went wrong' : 'No Data Found',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                                if (prov.reslut != null) Text(resultOf, style: subTextStyle, maxLines: 2),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: _style.scaleX(orientation == Orientation.landscape ? 15 : 30)),
                                if (orientation == Orientation.landscape || (orientation == Orientation.portrait && size.width > 999))
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: AnalyticsChart(
                                          key: const ValueKey('AnalyticsChart'),
                                          result: prov.reslut!,
                                        ),
                                      ),
                                      SizedBox(width: _style.scaleX(25)),

                                      /// TODO : Change rqage selection color
                                      Expanded(
                                        flex: 1,
                                        child: AnalyticsDetails(
                                          key: const ValueKey('AnalyticsDetails'),
                                          style: _style,
                                          textStyle: textStyle,
                                          size: size,
                                          subTextStyle: subTextStyle,
                                          totalWatchTime: prov.reslut!.totalWatchTimeHr.formatInDuration(),
                                          totalAverageWatchTime: prov.reslut!.totalAvgWatchTimeHr.formatInDuration(),
                                          resultOf: resultOf,
                                        ),
                                      ),
                                    ],
                                  )
                                else ...[
                                  AnalyticsChart(
                                    key: const ValueKey('AnalyticsChart'),
                                    result: prov.reslut!,
                                  ),
                                  SizedBox(height: _style.scaleX(25)),
                                  AnalyticsDetails(
                                    key: const ValueKey('AnalyticsDetails'),
                                    style: _style,
                                    textStyle: textStyle,
                                    size: size,
                                    subTextStyle: subTextStyle,
                                    totalWatchTime: prov.reslut!.totalWatchTimeHr.formatInDuration(),
                                    totalAverageWatchTime: prov.reslut!.totalAvgWatchTimeHr.formatInDuration(),
                                    resultOf: resultOf,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                    ],
                  )
                : NoInternetScreen(onRetry: () => notifier.checkNow());
          }),
        ),
      ),
    );
  }
}

// class NoDataFound extends StatelessWidget {
//   final String? message;
//   final String? buttonLable;
//   final VoidCallback? onRetry;
//   const NoDataFound({super.key, this.message, this.buttonLable, this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: Dimensions.PADDING_SIZE_DEFAULT,
//           vertical: Dimensions.PADDING_SIZE_DEFAULT,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               message ?? 'Unable to fetch Data',
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
//             TextButton(onPressed: onRetry, child: Text(buttonLable ?? 'Retry')),
//           ],
//         ),
//       ),
//     );
//   }
// }
