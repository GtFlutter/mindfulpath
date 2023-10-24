import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/base/shared_preferences_provider.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/theme/theme.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

//// TODO : What I Did In This Project
///  Intial Figma Design Implemented Not Implemented Chnages
///  Added Watch Time In Vedio Player api integrate
///  Analytics Screen Api Integrated
///
/// // TODO See Size height and minHeight For Custome Scrollabel column layout
// TODO also see extra code remove
// TODO For IOS Number keyboard show Done Using Scaffold
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );
  final prefs = await SharedPreferences.getInstance();

  return runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfigs.APP_NAME,
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
