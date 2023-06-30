import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/ui/app_scaffold.dart';
import 'package:meditation_app/ui/screens/sign_in_up_screen.dart';
import 'package:meditation_app/ui/screens/splash_screen.dart';

final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigator = GlobalKey(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: rootNavigator,
  // initialLocation: RouteHelper.splash,
  debugLogDiagnostics: false,
  routes: [
    ShellRoute(
      parentNavigatorKey: rootNavigator,
      navigatorKey: shellNavigator,
      builder: (context, state, child) {
        return AppScaffold(key: state.pageKey, child: child);
      },
      routes: [
        GoRoute(
          parentNavigatorKey: shellNavigator,
          path: ScreenPaths.splash,
          builder: (context, state) {
            return SplashScreen(key: state.pageKey);
          },
        ),
        GoRoute(
          parentNavigatorKey: shellNavigator,
          path: ScreenPaths.signInUp,
          builder: (context, state) {
            return SignInUpScreen(key: state.pageKey);
          },
        ),
      ],
    ),
  ],
);
