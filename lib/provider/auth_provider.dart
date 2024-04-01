import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/repositories/auth_repo.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/provider/repo_provider/auth_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/authentication/otp_verification_screen.dart';
import 'package:meditation_app/util/constants.dart';

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  final repo = ref.watch(authRepoProvider);
  return AuthNotifier(repo);
});

class AuthNotifier extends ChangeNotifier {
  final AuthRepo repo;

  AuthNotifier(this.repo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
  Future<void> requestOTP(
      {required String countryCode,
      required String phoneNo,
      required SendOTP type,
      String? password,
      bool shouldReplace = false}) async {
    assert(!(type == SendOTP.register && password == null));
    if (!shouldReplace) {
      startProgress();
    } else {
      showCustomSnackBar('Resending OTP');
    }
    Response response = await repo.requestOTP(countryCode + phoneNo, type);
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
              countryCode: countryCode,
              phoneNo: phoneNo,
              password: password,
            ),
          );
        } else {
          context.pushReplacement(
            RoutePath.otpVerificationScreen,
            extra: OTPModel(
              otp: otp,
              type: type,
              countryCode: countryCode,
              phoneNo: phoneNo,
              password: password,
            ),
          );
        }
        return;
      }
    }
    showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
  }

  /// Password is required for type == SendOTP.register
  Future<void> verifyOTP({
    required String countryCode,
    required String phoneNo,
    required SendOTP type,
    required int otp,
    String? password,
  }) async {
    assert(!(type == SendOTP.register && password == null));

    startProgress();
    Response response = await repo.verifyOTP(countryCode + phoneNo, otp);
    stopProgress();
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
      return;
    }
    BuildContext? context = rootNavigator.currentContext;
    if (context != null && context.mounted) {
      if (type == SendOTP.register) {
        context.pushReplacement(RoutePath.createNewProfileScreen, extra: (countryCode + phoneNo, password));
      } else if (type == SendOTP.forgotPwd) {
        context.pushReplacement(RoutePath.createNewPasswordScreen, extra: countryCode + phoneNo);
      }
    }
  }

  Future<void> loginUser(String phoneNo, String password,String fcmToken) async {
    startProgress();
    Response response = await repo.loginUser(phoneNo, password,fcmToken);
    if (response.statusCode != 200) {
      stopProgress();
      ApiChecker.checkApi(response);
      return;
    }
    if (response.statusCode == 200) {
      try {
        String? token = jsonDecode(response.body)['data']['token'];
        await repo.clearUserData();
        if (token != null) {
          await repo.saveUserToken(token);
        }
        stopProgress();
        showCustomSnackBar('Sign In Successfully', type: true);
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

  Future<void> resetPassword(String phoneNo, String password) async {
    startProgress();
    Response response = await repo.resetPassword(phoneNo, password);
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

  Future<void> logoutUser() async {
    startProgress();
    await repo.logoutUser();
    await repo.clearUserData();
    stopProgress();
    BuildContext? context = rootNavigator.currentContext;
    if (context != null && context.mounted) {
      context.go(RoutePath.splash);
    }
  }

  bool get isUserLoggedIn => repo.isUserLoggedIn;
}
