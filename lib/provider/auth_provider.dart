import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  Future<void> requestOTP(String countryCode, String phoneNo, SendOTP type) async {
    startProgress();
    Response response = await repo.requestOTP(countryCode + phoneNo, type);
    if (response.statusCode != 200) {
      stopProgress();
      ApiChecker.checkApi(response);
      return;
    }
    int? otp;
    try {
      otp = jsonDecode(response.body)['data']['otp'];
    } catch (_) {
      otp = null;
    }
    if (otp != null) {
      stopProgress();
      BuildContext? context = rootNavigator.currentContext;
      if (context != null && context.mounted) {
        context.push(
          RoutePath.otpVerificationScreen,
          extra: TempOtpModel(
            otp: otp,
            type: type,
            countryCode: countryCode,
            phoneNo: phoneNo,
          ),
        );
      }
    } else {
      showCustomSnackBar('Something went wrong! Please try again');
      stopProgress();
    }
  }
}
