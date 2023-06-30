import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/helper/router.dart';
import 'package:meditation_app/theme/theme.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/app_scaffold.dart';
import 'package:meditation_app/util/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // TODO Create a Provider For AppStyle
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.APP_NAME,
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}

AppStyle get $style => AppScaffold.style;
