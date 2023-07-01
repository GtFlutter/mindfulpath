import 'package:flutter/material.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/theme/styles.dart';
import '../theme/text_style.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});
  final Widget child;
  static AppStyle get style => _style;
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    debugPrint('Rebuilding App Scaffold');
    var query = MediaQuery.of(context);

    _style = AppStyle(screenSize: query.size);
    return KeyedSubtree(
      key: ValueKey($style.scale),
      child: Theme(
        data: Theme.of(context).copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            // iconTheme: IconThemeData(color: AppColors.secondaryClr),
            elevation: 0,
            titleTextStyle: $style.text.font(mulishMedium500, sizePx: 22.5),
            toolbarHeight: kToolbarHeight + ($style.scale * query.size.height < 800 ? 0.0 : 28.5),
          ),
        ),
        child: child,
      ),
    );
  }
}
