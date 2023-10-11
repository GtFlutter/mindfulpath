import 'package:flutter/material.dart';

import '../../../../../theme/styles.dart';

class AnalyticsDetails extends StatelessWidget {
  const AnalyticsDetails({
    super.key,
    required AppStyle style,
    required this.textStyle,
    required this.size,
    required this.subTextStyle,
  }) : _style = style;

  final AppStyle _style;
  final TextStyle textStyle;
  final Size size;
  final TextStyle subTextStyle;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: _style.scaleX(25)),
                Text(
                  'Total category time',
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: _style.scaleX(25)),
                Text(
                  'Total video time',
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: _style.scaleX(25)),
                Text(
                  'Total average time',
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: _style.scaleX(25)),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.shortestSide * 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  '1h 20m 14s',
                  style: subTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '45m',
                  style: subTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '2h 21m 8s',
                  style: subTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
