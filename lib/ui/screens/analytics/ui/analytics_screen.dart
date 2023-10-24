import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/helper/date_converter.dart';
import 'package:meditation_app/ui/screens/analytics/data/helper/analytics_enums.dart';
import 'package:meditation_app/ui/screens/analytics/data/provider/analytics_provider.dart';
import 'package:meditation_app/ui/screens/analytics/ui/widget/analytics_chart.dart';
import 'package:meditation_app/ui/screens/analytics/ui/widget/analytics_details.dart';
import 'package:meditation_app/util/dimensions.dart';

import '../../../../provider/auth_provider.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../common/background_image.dart';
import '../../../common/custom_app_bar.dart';
import '../../../common/sign_in_require.dart';
import 'widget/analytics_filter.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    ref.read(analyticsProvider).initData(notifie: false);
    if (ref.read(authProvider).isUserLoggedIn) {
      Future.delayed(Duration.zero, ref.read(analyticsProvider).getCategoryNamesList);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var orientation = MediaQuery.orientationOf(context);
    _style = AppStyle(screenSize: size);

    var prov = ref.watch(analyticsProvider);

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
            onPressed: prov.loading ? null : () => prov.reset(),
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

            // if (prov.categories.isEmpty) {
            //   return NoDataFound(onRetry: () {});
            // }

            return Column(
              children: [
                AbsorbPointer(
                  absorbing: prov.loading,
                  child: AnalyticsFilter(
                    _style,
                    size,
                    categoryValue: prov.categoryId,
                    videoValue: prov.videoId,
                    durationtypeValue: prov.durationtype,
                    categories: prov.categories,
                    videos: prov.videos,
                    durationtypes: FilterDuration.toList(),
                    onCategoryChanged: prov.onCategoryChanged,
                    onVideoChanged: prov.onVideoChanged,
                    onDurationTypeChanged: prov.onDurationTypeChanged,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(left: _style.scaleX(20), right: _style.scaleX(20)),
                    child: Text(
                      '${prov.duration.start.toStringFormat3}${prov.durationtype != FilterDuration.day ? ' To ${prov.duration.end.toStringFormat3}' : ''}',
                      style: subTextStyle,
                      maxLines: 2,
                    ),
                  ),
                ),
                Expanded(
                  child: prov.loading
                      ? const Center(child: CircularProgressIndicator())
                      : prov.reslut == null
                          ? NoDataFound(message: 'Something went wron', onRetry: () {})
                          : prov.reslut!.statistics.isEmpty
                              ? NoDataFound(message: 'No Data Found', onRetry: () {})
                              : SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: _style.scaleX(orientation == Orientation.landscape ? 15 : 30)),
                                      if (orientation == Orientation.landscape ||
                                          (orientation == Orientation.portrait && size.width > 999))
                                        Row(
                                          children: [
                                            const Expanded(child: AnalyticsChart(key: ValueKey('AnalyticsChart'))),
                                            SizedBox(width: _style.scaleX(25)),
                                            Expanded(
                                              child: AnalyticsDetails(
                                                key: const ValueKey('AnalyticsDetails'),
                                                style: _style,
                                                textStyle: textStyle,
                                                size: size,
                                                subTextStyle: subTextStyle,
                                              ),
                                            ),
                                          ],
                                        )
                                      else ...[
                                        const AnalyticsChart(
                                          key: ValueKey('AnalyticsChart'),
                                        ),
                                        SizedBox(height: _style.scaleX(25)),
                                        AnalyticsDetails(
                                          key: const ValueKey('AnalyticsDetails'),
                                          style: _style,
                                          textStyle: textStyle,
                                          size: size,
                                          subTextStyle: subTextStyle,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class NoDataFound extends StatelessWidget {
  final String? message;
  final String? buttonLable;
  final VoidCallback? onRetry;
  const NoDataFound({super.key, this.message, this.buttonLable, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT,
          vertical: Dimensions.PADDING_SIZE_DEFAULT,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? 'Unable to fetch Data',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
            TextButton(onPressed: onRetry, child: Text(buttonLable ?? 'Retry')),
          ],
        ),
      ),
    );
  }
}
