import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/database/database_model.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/ui/common/pdf_viewer/pdf_viewer_screen.dart';
import 'package:meditation_app/ui/screens/analytics/ui/analytics_screen.dart';
import 'package:meditation_app/ui/screens/authentication/create_new_password_screen.dart';
import 'package:meditation_app/ui/screens/authentication/create_profile_screen.dart';
import 'package:meditation_app/ui/screens/authentication/forgot_password_screen.dart';
import 'package:meditation_app/ui/screens/authentication/otp_verification_screen.dart';
import 'package:meditation_app/ui/screens/authentication/sign_in_up_screen.dart';
import 'package:meditation_app/ui/screens/category/detail_category_screen.dart';
import 'package:meditation_app/ui/screens/category/download_detail_category_screen.dart';
import 'package:meditation_app/ui/screens/courses/courses_list_screen.dart';
import 'package:meditation_app/ui/screens/discover/discover_screen.dart';
import 'package:meditation_app/ui/screens/library/library_screen.dart';
import 'package:meditation_app/ui/screens/notifications/notifications_screen.dart';
import 'package:meditation_app/ui/screens/playlist/sub_playlist_screen.dart';
import 'package:meditation_app/ui/screens/profile/profile_screen.dart';
import 'package:meditation_app/ui/screens/search/featured_video_screen.dart';
import 'package:meditation_app/ui/screens/search/search_screen.dart';
import 'package:meditation_app/ui/screens/settings/settings_screen.dart';
import 'package:meditation_app/ui/screens/settings/tc_pp_screen.dart';
import 'package:meditation_app/ui/screens/shellnav/shell_route.dart';
import 'package:meditation_app/ui/screens/splash_screen.dart';
import 'package:meditation_app/ui/screens/support/support_screen.dart';
import 'package:meditation_app/ui/screens/support/support_section_screen.dart';
import 'package:meditation_app/ui/screens/update_profile/update_profile_screen.dart';

import '../../ui/screens/category/widget/detail_item.dart';

final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigator = GlobalKey(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: rootNavigator,
  initialLocation: RoutePath.discoverScreen,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.splash,
      builder: (context, state) {
        return SplashScreen(key: state.pageKey);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.signIn,
      builder: (context, state) {
        return SignInUpScreen(key: state.pageKey, isSignIn: true);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.signUp,
      builder: (context, state) {
        return SignInUpScreen(key: state.pageKey, isSignIn: false);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.otpVerificationScreen,
      builder: (context, state) {
        return OtpVerificationScreen(key: state.pageKey, model: state.extra as OTPModel);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.forgotPasswordScreen,
      builder: (context, state) {
        return ForgotPasswordScreen(key: state.pageKey);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.createNewPasswordScreen,
      builder: (context, state) {
        return CreateNewPasswordScreen(
          key: state.pageKey,
          phoneNo: state.extra as String? ?? '',
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.createNewProfileScreen,
      builder: (context, state) {
        return CreateProfileScreen(
          key: state.pageKey,
          value: state.extra != null ? state.extra as (String, String) : ('', ''),
        );
      },
    ),

    /// TODO For Call This Screen Pass Bool Param For Is
    /// False For Privacy Policy And True For Terms And Conditions
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.tCPpScreen,
      builder: (context, state) {
        return TCPPScreen(
          key: state.pageKey,
          isTermsAndConditions: state.extra != null ? state.extra as bool : true,
        );
      },
    ),

    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.search,
      builder: (context, state) {
        return SearchScreen(key: state.pageKey);
      },
    ),

    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.featuredVideoScreen,
      builder: (context, state) {
        return FeaturedVideoScreen(key: state.pageKey);
      },
    ),

    /// Common
    GoRoute(
      parentNavigatorKey: rootNavigator,
      path: RoutePath.pdfViewer,
      builder: (context, state) {
        if (state.extra is String) {
          return PdfViewer.network(key: state.pageKey, url: state.extra as String);
        }
        return const WentWrongScreen();
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
            path: RoutePath.libraryScreen,
            builder: (context, state) {
              return LibraryScreen(key: state.pageKey);
            },
            routes: [
              GoRoute(
                path: RoutePath.coursesListScreen,
                builder: (context, state) {

                  return CoursesListScreen(
                    key: state.pageKey,
                    title: state.extra as String? ?? 'Router Extra Not Found',
                    isAudio: state.extra as bool? ?? false,
                  );
                },
              ),
              GoRoute(
                path: RoutePath.subPlaylistScreen,
                builder: (context, state) {
                  return SubPlayListScreen(
                    key: state.pageKey,
                    id: state.extra as int? ?? 0,
                    title: state.extra as String? ?? "",
                  );
                },
              ),
            ]),
        GoRoute(
            path: RoutePath.discoverScreen,
            builder: (context, state) {
              return DiscoverScreen(key: state.pageKey);
            },
            routes: [
              GoRoute(
                  parentNavigatorKey: rootNavigator,
                  path: RoutePath.profileScreen,
                  builder: (context, state) {
                    return ProfileScreen(key: state.pageKey);
                  },
                  routes: [
                    GoRoute(
                      parentNavigatorKey: rootNavigator,
                      path: RoutePath.editProfileScreen,
                      builder: (context, state) {
                        return UpdateProfileScreen(key: state.pageKey);
                      },
                    ),
                    GoRoute(
                      parentNavigatorKey: rootNavigator,
                      path: RoutePath.supportScreen,
                      builder: (context, state) {
                        return SupportScreen(key: state.pageKey);
                      },
                      routes: [
                        GoRoute(
                          parentNavigatorKey: rootNavigator,
                          path: RoutePath.supportSectionScreen,
                          builder: (context, state) {
                            return SupportSectionScreen(key: state.pageKey);
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      parentNavigatorKey: rootNavigator,
                      path: RoutePath.settingsScreen,
                      builder: (context, state) {
                        return SettingsScreen(key: state.pageKey);
                      },
                    ),
                    GoRoute(
                      parentNavigatorKey: rootNavigator,
                      path: RoutePath.notifications,
                      builder: (context, state) {
                        return NotificationsScreens(key: state.pageKey);
                      },
                    ),
                  ]),
              GoRoute(
                parentNavigatorKey: rootNavigator,
                path: RoutePath.detailCategoryScreen,
                builder: (context, state) {
                  if (state.extra != null && state.extra is (CategoryListResponse, DIModel?, bool)) {
                    var (category, video, isAudio) = state.extra as (CategoryListResponse, DIModel?, bool);
                    return DetailCategoryScreen(
                      key: state.pageKey,
                      iAudioView: isAudio,
                      categoryListResponse: category,
                      initialVideo: video,
                    );
                  }
                  return const WentWrongScreen();
                },
              ),
              GoRoute(
                parentNavigatorKey: rootNavigator,
                path: RoutePath.downloadDetailCategoryScreen,
                builder: (context, state) {
                  if (state.extra != null && state.extra is (CategoryModal,bool)) {
                    var (category, isAudio) = state.extra as (CategoryModal, bool);
                    return DownloadDetailCategoryScreen(key: state.pageKey, categoryModal: category, isAudio: isAudio,);
                  }
                  return const WentWrongScreen();
                },
              ),
            ]),
        GoRoute(
          path: RoutePath.analyticsScreen,
          builder: (context, state) {
            return AnalyticsScreen(key: state.pageKey);
          },
        ),
      ],
    ),
  ],
);

class WentWrongScreen extends StatelessWidget {
  const WentWrongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Something went wrong'),
      ),
    );
  }
}
