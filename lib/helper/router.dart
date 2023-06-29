import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route_helper.dart';
import 'package:meditation_app/views/sign_in_up_screen.dart';
import 'package:meditation_app/views/splash_screen.dart';

final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
// final GlobalKey<NavigatorState> shellNavigator = GlobalKey(debugLabel: 'shell');

final router = GoRouter(
  navigatorKey: rootNavigator,
  initialLocation: RouteHelper.splash,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RouteHelper.splash,
      builder: (context, state) {
        return SplashScreen(key: state.pageKey);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RouteHelper.signInUp,
      builder: (context, state) {
        return SignInUpScreen(key: state.pageKey);
      },
    ),
  ],
);
