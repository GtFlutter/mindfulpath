import 'package:flutter/material.dart';
import 'package:meditation_app/theme/styles.dart';

class CustomScrollableColumnLayout extends StatelessWidget {
  final List<Widget> children;
  final double minHeight;

  /// This only for testing minimum height
  final double? testScreenHeight;
  final EdgeInsetsGeometry? padding;
  final AppStyle style;

  const CustomScrollableColumnLayout({
    super.key,
    required this.minHeight,
    this.children = const <Widget>[],
    this.padding,
    this.testScreenHeight,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    // var query = MediaQuery.of(context);
    // This removing already occupi by some ui like appbar,statusbar notch, bottom navigation button (back,home,recent)
    // var alredyOccupiedHeight = kToolbarHeight +
    //     (style.scale * query.size.height < 800 ? 0.0 : 28.5) +
    //     query.viewPadding.top +
    //     query.viewPadding.bottom +
    //     24;
    // var height = testScreenHeight ?? query.size.height - alredyOccupiedHeight;
    return Container(
      width: double.infinity,
      height: double.infinity,
      constraints: BoxConstraints(maxWidth: 500 * style.scale),
      child: LayoutBuilder(
        builder: (context, constraints) {
          var height = testScreenHeight ?? constraints.biggest.height;
          return SingleChildScrollView(
            padding: padding ?? EdgeInsets.symmetric(horizontal: style.scale * 25),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height <= minHeight ? minHeight : height,
                  child: Column(children: children),
                ),
              ],
            ),
          );
        },
      ),
    );
    // return SingleChildScrollView(
    //   padding: padding,
    //   child: Column(
    //     children: [
    //       SizedBox(
    //         width: double.infinity,
    //         height: height <= minHeight ? minHeight : height,
    //         child: Column(children: children),
    //       ),
    //     ],
    //   ),
    // );
  }
}
