import 'package:flutter/material.dart';
import 'package:meditation_app/ui/screens/analytics/ui/widget/analytics_chart.dart';
import 'package:meditation_app/ui/screens/analytics/ui/widget/analytics_details.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../common/background_image.dart';
import '../../../common/custom_app_bar.dart';
import 'widget/analytics_filter.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var orientation = MediaQuery.orientationOf(context);

    _style = AppStyle(screenSize: size);

    TextStyle textStyle = _style.text.font(mulishMedium500, sizePx: 12.5);
    TextStyle subTextStyle = _style.text.font(mulishRegular400, sizePx: 10);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      // appBar: AppBar(
      //   title: const Text('Analytics'),
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   titleTextStyle: _style.text.font(mulishSemiBold600, sizePx: 15, color: Colors.white),
      // ),
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Analytics',
        automaticallyImplyLeading: false,
      ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Column(
            children: [
              const AnalyticsFilter(),
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
          ),
        ),
      ),
    );
  }
}
