import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/ui/screens/analytics/data/provider/analytics_provider.dart';
import 'package:meditation_app/ui/screens/analytics/ui/widget/analytics_chart.dart';
import 'package:meditation_app/ui/screens/analytics/ui/widget/analytics_details.dart';
import 'package:meditation_app/util/dimensions.dart';

import '../../../../helper/route/route_paths.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../common/background_image.dart';
import '../../../common/custom_app_bar.dart';
import '../data/model/response/category_and_video_name_model.dart';
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
    Future.delayed(
      Duration.zero,
      ref.read(analyticsProvider).getCategoryNamesList,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(analyticsProvider);

    var size = MediaQuery.of(context).size;
    var orientation = MediaQuery.orientationOf(context);

    _style = AppStyle(screenSize: size);

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
      ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Builder(builder: (context) {
            if (!ref.read(authProvider).isUserLoggedIn) {
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
                        'Login to access your analytics',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                      FilledButton(
                        onPressed: () => context.go(RoutePath.signIn),
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (prov.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (prov.categories.isEmpty) {
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
                        'Unable to fetch Category',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                AnalyticsFilter(
                  categoryList: prov.categories,
                  onCategoryChanged: (value) {},
                  videoList: prov.videos,
                  onVideoChanged: (value) {},
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: _style.scaleX(orientation == Orientation.landscape ? 15 : 30)),
                        if (orientation == Orientation.landscape ||
                            (orientation == Orientation.portrait && size.width > 999))
                          Row(
                            children: [
                              const Expanded(
                                  child: AnalyticsChart(
                                key: ValueKey('value'),
                              )),
                              SizedBox(width: _style.scaleX(25)),
                              Expanded(
                                child: AnalyticsDetails(
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
                            key: ValueKey('value'),
                          ),
                          SizedBox(height: _style.scaleX(25)),
                          AnalyticsDetails(
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
