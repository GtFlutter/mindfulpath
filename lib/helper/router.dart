import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/ui/screens/analytics/analytics_screen.dart';
import 'package:meditation_app/ui/screens/authentication/create_new_password_screen.dart';
import 'package:meditation_app/ui/screens/authentication/create_new_profile_screen.dart';
import 'package:meditation_app/ui/screens/authentication/forgot_password_screen.dart';
import 'package:meditation_app/ui/screens/authentication/otp_verification_screen.dart';
import 'package:meditation_app/ui/screens/authentication/sign_in_up_screen.dart';
import 'package:meditation_app/ui/screens/category/detail_category_screen.dart';
import 'package:meditation_app/ui/screens/discover/discover_screen.dart';
import 'package:meditation_app/ui/screens/library/library_screen.dart';
import 'package:meditation_app/ui/screens/shellnav/shell_route.dart';
import 'package:meditation_app/ui/screens/splash_screen.dart';
import 'package:meditation_app/ui/screens/settings/tc_pp_screen.dart';

final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigator = GlobalKey(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: rootNavigator,
  initialLocation: ScreenPaths.discoverScreen,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: ScreenPaths.splash,
      builder: (context, state) {
        return SplashScreen(key: state.pageKey);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: ScreenPaths.signInUp,
      builder: (context, state) {
        return SignInUpScreen(key: state.pageKey, isSignIn: false);
        // return SignInUpScreen(key: state.pageKey, isSignIn: state.extra as bool);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: ScreenPaths.otpVerificationScreen,
      builder: (context, state) {
        return OtpVerificationScreen(key: state.pageKey, model: state.extra as TempOtpModel);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: ScreenPaths.forgotPasswordScreen,
      builder: (context, state) {
        return ForgotPasswordScreen(key: state.pageKey);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: ScreenPaths.createNewPasswordScreen,
      builder: (context, state) {
        return CreateNewPasswordScreen(key: state.pageKey);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: ScreenPaths.createNewProfileScreen,
      builder: (context, state) {
        return CreateNewProfileScreen(key: state.pageKey);
      },
    ),

    /// TODO For Call This Screen Pass Bool Param For Is
    /// Fals For Privacy Policy And True Terms And Conditions
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: ScreenPaths.tCPpScreen,
      builder: (context, state) {
        return TCPPScreen(
          key: state.pageKey,
          isTermsAndConditions: state.extra != null ? state.extra as bool : true,
        );
      },
    ),

    ShellRoute(
      parentNavigatorKey: rootNavigator,
      navigatorKey: shellNavigator,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: ScreenPaths.libraryScreen,
          builder: (context, state) {
            return LibraryScreen(key: state.pageKey);
          },
        ),
        GoRoute(
            path: ScreenPaths.discoverScreen,
            builder: (context, state) {
              return DiscoverScreen(key: state.pageKey);
            },
            routes: [
              GoRoute(
                path: ScreenPaths.detailScreen,
                builder: (context, state) {
                  return DetailCategoryScreen(key: state.pageKey);
                },
              ),
            ]),
        GoRoute(
          path: ScreenPaths.analyticsScreen,
          builder: (context, state) {
            return AnalyticsScreen(key: state.pageKey);
          },
        ),
      ],
    ),
  ],
);
