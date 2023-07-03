import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/ui/app_scaffold.dart';
import 'package:meditation_app/ui/screens/authentication/create_new_password_screen.dart';
import 'package:meditation_app/ui/screens/authentication/create_new_profile_screen.dart';
import 'package:meditation_app/ui/screens/authentication/forgot_password_screen.dart';
import 'package:meditation_app/ui/screens/authentication/otp_verification_screen.dart';
import 'package:meditation_app/ui/screens/authentication/sign_in_up_screen.dart';
import 'package:meditation_app/ui/screens/splash_screen.dart';
import 'package:meditation_app/ui/screens/settings/tc_pp_screen.dart';

final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigator = GlobalKey(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: rootNavigator,
  initialLocation: ScreenPaths.tCPpScreen,
  debugLogDiagnostics: true,
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
            return SignInUpScreen(key: state.pageKey, isSignIn: state.extra as bool);
          },
        ),
        GoRoute(
          parentNavigatorKey: shellNavigator,
          path: ScreenPaths.otpVerificationScreen,
          builder: (context, state) {
            return OtpVerificationScreen(key: state.pageKey, model: state.extra as TempOtpModel);
          },
        ),
        GoRoute(
          parentNavigatorKey: shellNavigator,
          path: ScreenPaths.forgotPasswordScreen,
          builder: (context, state) {
            return ForgotPasswordScreen(key: state.pageKey);
          },
        ),
        GoRoute(
          parentNavigatorKey: shellNavigator,
          path: ScreenPaths.createNewPasswordScreen,
          builder: (context, state) {
            return CreateNewPasswordScreen(key: state.pageKey);
          },
        ),
        GoRoute(
          parentNavigatorKey: shellNavigator,
          path: ScreenPaths.createNewProfileScreen,
          builder: (context, state) {
            return CreateNewProfileScreen(key: state.pageKey);
          },
        ),
        GoRoute(
          parentNavigatorKey: shellNavigator,
          path: ScreenPaths.tCPpScreen,
          builder: (context, state) {
            return TCPPScreen(key: state.pageKey);
          },
        ),
      ],
    ),
  ],
);
