import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/firebase_options.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/provider/base/shared_preferences_provider.dart';
import 'package:meditation_app/theme/theme.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

//// TODO : What I Did In This Project
///  Intial Figma Design Implemented Not Implemented Chnages
///  sign in and sign up api integrated
///  Added Watch Time In Vedio Player api integrate
///  Analytics Screen Api Integrated
///
// TODO See Size height and minHeight For Custome Scrollabel column layout
// TODO also see extra code remove
// TODO For IOS Number keyboard show Done Using Scaffold
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'Meditation',
      options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
    // debugPrint('screenSize=$screenSize, scale=$scale');
    final scale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2);
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: scale),
      child: MaterialApp.router(
        title: AppConfigs.APP_NAME,
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: appRouter,
      ),
    );
  }
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  print("Handling a background message: ${remoteMessage.toMap()}");
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final send = IsolateNameServer.lookupPortByName('notification');
  send?.send(remoteMessage.data);
}

/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/theme/theme.dart';
import 'package:meditation_app/util/app_config.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );

  return runApp(
      const MainApp()
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfigs.APP_NAME,
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  // *****
  // *****
  // *****
  // *****
  // *****

  void patternProgramming1(){
    int row = 5;
    for (int i = 1; i <= row; i++) {
      for (int j = 1; j <= row; j++) {
        print("*");
      }
      print("\n");
    }
  }

  // *
  // **
  // ***
  // ****
  // *****

  void patternProgramming2(){
    int row = 5;
    for (int i = 1; i <= row; i++) {
      for (int j = 1; j <= i; j++) {
        print("*");
      }
      print("\n");
    }
  }

  // *****
  // ****
  // ***
  // **
  // *

  void patternProgramming3(){
    int row = 5;
    for(int i = row ; i >= 1 ; i++){
      for(int j = i ; j >= 1 ; j++){
        print("*");
      }
      print("\n");
    }
  }

}*/
