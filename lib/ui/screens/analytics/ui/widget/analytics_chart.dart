import 'package:flutter/material.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../theme/styles.dart';
import '../../../../../theme/text_style.dart';
import '../../data/model/response/analytics_result_model.dart';

extension OnInt on int {
  double secondsInDays() => this / (60 * 60 * 24);
  double secondsInHours() => this / (60 * 60);
  double secondsInMinutes() => this / 60;
}

enum AxisYValueFormate {
  days('D'),
  hours('H'),
  minutes('M'),
  seconds('S');

  final String shortName;
  const AxisYValueFormate(this.shortName);
}

class AnalyticsChart extends StatefulWidget {
  final AnalyticsResult result;
  const AnalyticsChart({super.key, required this.result});

  @override
  State<AnalyticsChart> createState() => _AnalyticsChartState();
}

class _AnalyticsChartState extends State<AnalyticsChart> {
  static AppStyle _style = AppStyle();

  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  int _calculateMaxDuration(List<Statistic> statistics) {
    return statistics
        .map(
          (item) => item.totalDurationInSecond,
        )
        .reduce(
          (value, item) => value + item,
        );
  }

  double _calculateY(AxisYValueFormate valueFormat, int seconds) {
    switch (valueFormat) {
      case AxisYValueFormate.days:
        return seconds.secondsInDays();
      case AxisYValueFormate.hours:
        return seconds.secondsInHours();
      case AxisYValueFormate.minutes:
        return seconds.secondsInMinutes();
      case AxisYValueFormate.seconds:
        return seconds.toDouble();
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// For Horizintal Axis
    ShowType type = widget.result.toShowType();

    /// For Verticle Axis
    int maxDurationInSeconds = _calculateMaxDuration(widget.result.statistics);

    if (widget.result.statistics.isEmpty || maxDurationInSeconds <= 0 || type == ShowType.unknown) {
      return const Center(child: Text('No data found'));
    }

    Duration maxDuratrion = Duration(seconds: maxDurationInSeconds);

    double min = 0;
    double max = 0;
    AxisYValueFormate valueFormate;
    List<_ChartData> data = [];

    if (maxDuratrion.inDays != 0 && maxDuratrion.inHours != 24) {
      valueFormate = AxisYValueFormate.days;
      max = maxDurationInSeconds.secondsInDays().ceil().toDouble();
    } else if (maxDuratrion.inHours != 0 && maxDuratrion.inMinutes != 60) {
      valueFormate = AxisYValueFormate.hours;
      max = maxDurationInSeconds.secondsInHours().ceil().toDouble();
    } else if (maxDuratrion.inMinutes >= 1 && maxDuratrion.inSeconds != 60) {
      valueFormate = AxisYValueFormate.minutes;
      max = maxDurationInSeconds.secondsInMinutes().ceil().toDouble();
    } else {
      max = maxDurationInSeconds.toDouble();
      valueFormate = AxisYValueFormate.seconds;
    }

    for (var element in widget.result.statistics) {
      String x = type == ShowType.weekDayName ? element.dayName : element.monthName;
      double y = _calculateY(valueFormate, element.totalDurationInSecond);
      data.add(_ChartData(x, y));
    }

    var orientation = MediaQuery.orientationOf(context);
    var size = MediaQuery.sizeOf(context);
    _style = AppStyle(screenSize: size);
    return Container(
      constraints: BoxConstraints(
        maxHeight: orientation == Orientation.landscape ? size.shortestSide * 0.5 : double.infinity,
      ),
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
          zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
          enableAxisAnimation: true,
          primaryXAxis: CategoryAxis(
            arrangeByIndex: true,
            rangePadding: ChartRangePadding.round,
            majorGridLines: const MajorGridLines(color: Colors.transparent, width: 0),
            majorTickLines: const MajorTickLines(color: Colors.transparent, width: 0),
            axisLine: const AxisLine(width: 0, color: Colors.transparent),
            labelStyle: _style.text.font(mulishRegular400, sizePx: 10),
            labelAlignment: LabelAlignment.center,
            labelPosition: ChartDataLabelPosition.outside,
            maximumLabels: 100,
            autoScrollingDelta: 12,
          ),
          primaryYAxis: NumericAxis(
            minimum: min.toDouble(),
            maximum: max.toDouble(),
            desiredIntervals: 4,
            decimalPlaces: 1,
            axisLine: const AxisLine(width: 0, color: Colors.transparent),
            majorGridLines: const MajorGridLines(color: Colors.transparent, width: 0),
            majorTickLines: const MajorTickLines(color: Colors.transparent, width: 0),
            labelAlignment: LabelAlignment.center,
            labelStyle: _style.text.font(mulishRegular400, sizePx: 10),
            labelFormat: '{value} ${valueFormate.shortName}',
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
              xValueMapper: (_ChartData data, _) => data.x.capitalizeFirstLetter,
              yValueMapper: (_ChartData data, _) => data.y,
              name: 'Analytics',
              width: 0.2,
              enableTooltip: false,
              // markerSettings: MarkerSettings(isVisible: true),
              isTrackVisible: false,
              borderRadius: BorderRadius.circular(_style.scaleX(50)),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primaryColor, Color(0x00FFC865)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
