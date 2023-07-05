import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/helper/router.dart';
import 'package:meditation_app/theme/theme.dart';
import 'package:meditation_app/util/constants.dart';

// TODO See Size height and minHeight For Custome Scrollabel column layout
// TODO also see extra code remove
// TODO For IOS Number keyboard show Done Using Scaffold
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
