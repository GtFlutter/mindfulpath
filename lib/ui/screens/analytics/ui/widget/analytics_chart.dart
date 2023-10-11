import 'package:flutter/material.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../theme/styles.dart';
import '../../../../../theme/text_style.dart';

class AnalyticsChart extends StatefulWidget {
  const AnalyticsChart({super.key});

  @override
  State<AnalyticsChart> createState() => _AnalyticsChartState();
}

class _AnalyticsChartState extends State<AnalyticsChart> {
  static AppStyle _style = AppStyle();

  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('Sun', 25),
      _ChartData('Mon', 20),
      _ChartData('Tue', 55),
      _ChartData('Wed', 30),
      _ChartData('Thu', 10),
      _ChartData('Fri', 5),
      _ChartData('Sat', 60)
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.orientationOf(context);
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    return Container(
      constraints:
          BoxConstraints(maxHeight: orientation == Orientation.landscape ? size.shortestSide * 0.5 : double.infinity),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_style.scaleX(30)),
        ),
        color: const Color(0xFF2D251F),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 335 / 253,
        child: SfCartesianChart(
            margin: EdgeInsets.fromLTRB(
              _style.scaleX(16),
              _style.scaleX(30),
              _style.scaleX(12.5),
              _style.scaleX(12.5),
            ),
            plotAreaBorderWidth: 0,
            plotAreaBorderColor: Colors.transparent,
            primaryXAxis: CategoryAxis(
              rangePadding: ChartRangePadding.auto,
              majorGridLines: const MajorGridLines(color: Colors.transparent, width: 0),
              majorTickLines: const MajorTickLines(color: Colors.transparent, width: 0),
              axisLine: const AxisLine(width: 0, color: Colors.transparent),
              labelStyle: _style.text.font(mulishRegular400, sizePx: 10),
              labelAlignment: LabelAlignment.center,
              labelPosition: ChartDataLabelPosition.outside,
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 60,
              axisLine: const AxisLine(width: 0, color: Colors.transparent),
              interval: 15,
              majorGridLines: const MajorGridLines(color: Colors.transparent, width: 0),
              majorTickLines: const MajorTickLines(color: Colors.transparent, width: 0),
              labelAlignment: LabelAlignment.center,
              labelStyle: _style.text.font(mulishRegular400, sizePx: 10),
              labelFormat: '{value} M',
              axisLabelFormatter: (axisLabelRenderArgs) {
                return ChartAxisLabel(
                  axisLabelRenderArgs.value == 0 ? axisLabelRenderArgs.text : axisLabelRenderArgs.text,
                  _style.text.font(mulishRegular400, sizePx: 10),
                );
              },
            ),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<_ChartData, String>>[
              ColumnSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                name: 'Analytics',
                width: 0.2,
                borderRadius: BorderRadius.circular(_style.scaleX(50)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primaryColor, Color(0x00FFC865)],
                ),
              )
            ]),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
