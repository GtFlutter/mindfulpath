import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/repositories/auth_repo.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/provider/repo_provider/auth_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/authentication/otp_verification_screen.dart';
import 'package:meditation_app/util/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/model/response/check_social_user_response.dart';
import '../notification_services.dart';
import '../ui/screens/authentication/create_profile_screen.dart';

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  final repo = ref.watch(authRepoProvider);
  return AuthNotifier(repo);
});

class AuthNotifier extends ChangeNotifier {
  final AuthRepo repo;
  NotificationServices notificationServices = NotificationServices();
  SocialUserData? socialUserData;
  String? mobileOrEmail;

  AuthNotifier(this.repo);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool plan = false;

  void startProgress() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void stopProgress() {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Password is required for type == SendOTP.register, If You Want To Replace Screen Then add shouldReplace = true
  Future<void> requestOTP({required String email, required SendOTP type, String? password, bool shouldReplace = false}) async {
    assert(!(type == SendOTP.register && password == null));
    if (!shouldReplace) {
      startProgress();
    } else {
      showCustomSnackBar('Resending OTP');
    }
    Response response = await repo.requestOTP(email, type);
    if (response.statusCode != 200) {
      if (!shouldReplace) stopProgress();
      ApiChecker.checkApi(response);
      return;
    }
    int? otp;
    try {
      otp = jsonDecode(response.body)['data']['otp'];
    } catch (_) {
      otp = null;
    }
    if (!shouldReplace) {
      stopProgress();
    }
    if (otp != null) {
      if (shouldReplace) showCustomSnackBar('OTP Sended Successfully $otp');
      BuildContext? context = rootNavigator.currentContext;
      if (context != null && context.mounted) {
        if (!shouldReplace) {
          context.push(
            RoutePath.otpVerificationScreen,
            extra: OTPModel(
              otp: otp,
              type: type,
              email: email,
              password: password,
            ),
          );
        } else {
          context.pushReplacement(
            RoutePath.otpVerificationScreen,
            extra: OTPModel(
              otp: otp,
              type: type,
              email: email,
              password: password,
            ),
          );
        }
        return;
      }
    }
    showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
  }

  ///check social user exist or not
  Future<bool> checkSocialUser(CheckSocialUserRequest request) async {
    startProgress();
    Response response = await repo.checkSocialUser(request);
    if (response.statusCode != 200) {
      stopProgress();
      ApiChecker.checkApi(response);
      return false;
    }
    if (response.statusCode == 200) {
      try {
        stopProgress();
        var jsonData = jsonDecode(response.body);
        final data = CheckSocialUserResponse.fromJson(jsonData);
        if (data.data != null) {
          if (data.data?.token != null) {
            showCustomSnackBar('Sign In Successfully', type: true);
            // await repo.clearUserData();
            await repo.saveUserToken(data.data?.token ?? "");
            BuildContext? context = rootNavigator.currentContext;
            if (context != null && context.mounted && data.data?.token != null) {
              context.go(RoutePath.discoverScreen);
            } else if (context != null && context.mounted) {
              context.go(RoutePath.signIn);
            }
          } else {
            stopProgress();
            BuildContext? context = rootNavigator.currentContext;
            if (context != null && context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateProfileScreen(),
                  ));
            }
          }
        }
        return true;
      } catch (_) {
        stopProgress();
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
      }
    }
    return false;
  }
  Future<void> googleLogin() async {
    try {
      final gLogin = GoogleSignIn(
        scopes: [
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'openid',
        ],
      );

      await gLogin.signOut(); // Optional: Clear any previous session

      GoogleSignInAccount? account = await gLogin.signIn();

      if (account == null) {
        // 🔙 User cancelled the login (pressed back or closed dialog)
        // showCustomSnackBar('Login cancelled by user.', type: false);
        return;
      }

      startProgress();

      // ✅ Login succeeded – get FCM token and check user
      String? fcmToken = await notificationServices.getDeviceToken();

      CheckSocialUserRequest request = CheckSocialUserRequest(
        socialId: account.id,
        email: account.email,
        fcmToken: fcmToken,
      );

      log('Account :: $account', name: 'GoogleAccount');

      bool? response = await checkSocialUser(request);

      if (response == true) {
        socialUserData = SocialUserData(
          userName: account.displayName,
          mobileOrEmail: account.email,
          socialId: account.id,
          isSocialLogin: true,
          fcmToken: fcmToken,
          isGoogleLogin: true,
        );

        mobileOrEmail = account.email;
      } else {
        showCustomSnackBar('Login failed: Invalid response from server.', type: false);
      }
    } on PlatformException catch (e) {
      // ⚠️ Specific Google sign-in issues (like Play Services not available)
      showCustomSnackBar('Google Sign-In error: ${e.message}', type: false);
    } on Exception catch (e) {
      // ❗ Other known exceptions
      showCustomSnackBar(e.toString().replaceAll('Exception:', '').trim(), type: false);
    } catch (e) {
      // ❗ Unexpected or unknown errors
      log('Google Login Error :: $e', name: 'LoginError');
      showCustomSnackBar('Something went wrong. Please try again.', type: false);
    } finally {
      stopProgress();
      notifyListeners();
    }
  }

  // ///google login
  // Future googleLogin() async {
  //   try {
  //     final gLogin =
  //         GoogleSignIn(scopes: ['https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/userinfo.profile', 'openid']);
  //     await gLogin.signOut();
  //     GoogleSignInAccount? account = await gLogin.signIn();
  //     if (account == null) {
  //       stopProgress();
  //       throw Exception('User account not found');
  //     }
  //     await gLogin.signOut();
  //     startProgress();
  //     String? fcmToken = await notificationServices.getDeviceToken();
  //     CheckSocialUserRequest request = CheckSocialUserRequest(socialId: account.id, email: account.email, fcmToken: fcmToken);
  //     log('Account :: $account', name: 'GoogleAccount');
  //
  //     bool? response = await checkSocialUser(request);
  //     // if (response == null) {
  //     //   throw Exception(unKnownError);
  //     // }
  //     if (response) {
  //       socialUserData = SocialUserData(
  //           userName: account.displayName,
  //           mobileOrEmail: account.email,
  //           socialId: account.id,
  //           isSocialLogin: true,
  //           fcmToken: fcmToken,
  //           isGoogleLogin: true);
  //
  //       mobileOrEmail = account.email;
  //     }
  //     stopProgress();
  //   } on Exception catch (e) {
  //     stopProgress();
  //     showCustomSnackBar(e.toString().replaceAll('Exception:', ''), type: false);
  //   } catch (e) {
  //     stopProgress();
  //     log('Google Login Error :: $e', name: 'LoginError');
  //   } finally {
  //     stopProgress();
  //   }
  //   notifyListeners();
  // }

  // Future<void> facebookAuth() async{
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
  //   final data = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   debugPrint("Facebook Creds ::: ${data.user}");
  // }

  /// Password is required for type == SendOTP.register
  Future<void> verifyOTP({
    required email,
    required SendOTP type,
    required int otp,
    String? password,
  }) async {
    assert(!(type == SendOTP.register && password == null));

    startProgress();
    Response response = await repo.verifyOTP(email, otp);
    stopProgress();
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
      return;
    }
    BuildContext? context = rootNavigator.currentContext;
    if (context != null && context.mounted) {
      if (type == SendOTP.register) {
        context.pushReplacement(RoutePath.createNewProfileScreen, extra: (email, password));
      } else if (type == SendOTP.forgotPwd) {
        context.pushReplacement(RoutePath.createNewPasswordScreen, extra: email);
      }
    }
  }

  Future<void> loginUser(String email, String password, String fcmToken) async {
    startProgress();
    Response response = await repo.loginUser(email, password, fcmToken);
    if (response.statusCode != 200) {
      stopProgress();
      ApiChecker.checkApi(response);
      return;
    }
    if (response.statusCode == 200) {
      try {
        String? token = jsonDecode(response.body)['data']['token'];
        // await repo.clearUserData();
        if (token != null) {
          await repo.saveUserToken(token);
        }
        showCustomSnackBar('Sign In Successfully', type: true);
        stopProgress();
        BuildContext? context = rootNavigator.currentContext;
        if (context != null && context.mounted && token != null) {
          context.go(RoutePath.discoverScreen);
        } else if (context != null && context.mounted) {
          context.go(RoutePath.signIn);
        }
      } catch (_) {
        stopProgress();
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
      }
    }
  }

  Future<void> resetPassword(String email, String password) async {
    startProgress();
    Response response = await repo.resetPassword(email, password);
    stopProgress();
    if (response.statusCode == 200) {
      showCustomSnackBar('Password Changed Successfully', type: true);
    } else {
      ApiChecker.checkApi(response);
    }
    BuildContext? context = rootNavigator.currentContext;
    if (context != null && context.mounted) {
      context.go(RoutePath.signIn);
    }
  }
  Future<void> deleteLocalDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'meditation_DB.db');

      await deleteDatabase(path);
      print('Database deleted successfully');
    } catch (e) {
      print('Error deleting database: $e');
    }
  }
  Future<void> logoutUser() async {
    startProgress();
    await repo.logoutUser();
    await repo.clearUserData();
    await deleteLocalDatabase();
    socialUserData = null;
    mobileOrEmail = null;
    stopProgress();
    BuildContext? context = rootNavigator.currentContext;
    if (context != null && context.mounted) {
      context.go(RoutePath.splash);
    }
  }

  bool get isUserLoggedIn => repo.isUserLoggedIn;
}
