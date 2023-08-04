import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/body/user_body.dart';
import 'package:meditation_app/data/model/response/new_user_response_error_model.dart';
import 'package:meditation_app/data/model/response/user_response.dart';
import 'package:meditation_app/data/repositories/auth_repo.dart';
import 'package:meditation_app/provider/repo_provider/auth_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';

import '../data/model/response/error_res_model.dart';
import '../data/model/response/response_error.dart';
import '../helper/route/route_paths.dart';
import '../helper/route/router.dart';
import '../util/constants.dart';

final userProvider = ChangeNotifierProvider<UserNotifier>((ref) {
  final repo = ref.watch(authRepoProvider);
  return UserNotifier(repo);
});

class UserNotifier extends ChangeNotifier {
  final AuthRepo repo;

  UserNotifier(this.repo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _nameErrorText;
  String? _emailErrorText;
  String? _dateErrorText;
  String? _genderErrorText;

  String? get nameErrorText => _nameErrorText;
  String? get emailErrorText => _emailErrorText;
  String? get dateErrorText => _dateErrorText;
  String? get genderErrorText => _genderErrorText;

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

  void clearAllErrorText({bool notifie = true}) {
    _nameErrorText = null;
    _emailErrorText = null;
    _dateErrorText = null;
    _genderErrorText = null;
    if (notifie) notifyListeners();
  }

  void setNameError({String? error, bool notifie = true}) {
    if (error == null && _nameErrorText == null) {
      return;
    }
    _nameErrorText = error;
    if (notifie) notifyListeners();
  }

  void setEmailError({String? error, bool notifie = true}) {
    if (error == null && _emailErrorText == null) {
      return;
    }
    _emailErrorText = error;
    if (notifie) notifyListeners();
  }

  void setDateError({String? error, bool notifie = true}) {
    if (error == null && _dateErrorText == null) {
      return;
    }
    _dateErrorText = error;
    if (notifie) notifyListeners();
  }

  void setGenderError({String? error, bool notifie = true}) {
    if (error == null && _genderErrorText == null) {
      return;
    }
    _genderErrorText = error;
    if (notifie) notifyListeners();
  }

  /// Use Router Extensions For Type Safe Routing
  /// ///
  Future<void> createUserProfile(UserBody model) async {
    startProgress();
    Response response = await repo.createUserProfile(model);
    if (response.statusCode == 200) {
      try {
        String? token = jsonDecode(response.body)['data']['token'];
        await repo.clearUserData();
        if (token != null) {
          await repo.saveUserToken(token);
        }
        stopProgress();
        showCustomSnackBar('Profile Created Successfully', type: true);
        BuildContext? context = rootNavigator.currentContext;
        if (context != null && context.mounted && token != null) {
          context.go(RoutePath.discoverScreen);
        } else if (context != null && context.mounted) {
          context.go(RoutePath.signIn);
        }
        return;
      } catch (_) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
      }
      stopProgress();
      return;
    }
    if (response.statusCode == 403 && jsonDecode(response.body)['data'] != null) {
      NewUserResponseErrorModel errorModel = NewUserResponseErrorModel.fromJson(jsonDecode(response.body)['data']);
      if (errorModel.phoneNo.isNotEmpty || errorModel.password.isNotEmpty) {
        stopProgress();
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        BuildContext? context = rootNavigator.currentContext;
        if (context != null && context.mounted) {
          context.go(RoutePath.signIn);
        }
      } else {
        if (errorModel.name.isNotEmpty) setNameError(error: errorModel.name.first, notifie: false);
        if (errorModel.email.isNotEmpty) setEmailError(error: errorModel.email.first, notifie: false);
        if (errorModel.birthDate.isNotEmpty) setDateError(error: errorModel.birthDate.first, notifie: false);
        if (errorModel.gender.isNotEmpty) setGenderError(error: errorModel.gender.first, notifie: false);
        stopProgress();
      }
      return;
    }
    stopProgress();
    ApiChecker.checkApi(response);
    BuildContext? context = rootNavigator.currentContext;
    if (context != null && context.mounted) {
      context.go(RoutePath.signIn);
    }
  }

  Future<void> updateUserProfile(UserBody model) async {
    startProgress();
    showCustomSnackBar('Updating Profile...');
    Response response = await repo.updateUserProfile(model);

    if (response.statusCode == 200) {
      stopProgress();
      showCustomSnackBar('Profile Updated Successfully', type: true);
      // _contextPopIfAvailable();
      return;
    }

    final data = jsonDecode(response.body);
    if (response.statusCode == 403 && data['data'] != null) {
      NewUserResponseErrorModel errorModel = NewUserResponseErrorModel.fromJson(data['data']);
      if (errorModel.phoneNo.isNotEmpty) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        _contextPopIfAvailable();
      } else {
        if (errorModel.name.isNotEmpty) setNameError(error: errorModel.name.first, notifie: false);
        if (errorModel.email.isNotEmpty) setEmailError(error: errorModel.email.first, notifie: false);
        if (errorModel.birthDate.isNotEmpty) setDateError(error: errorModel.birthDate.first, notifie: false);
        if (errorModel.gender.isNotEmpty) setGenderError(error: errorModel.gender.first, notifie: false);
      }
      stopProgress();
      return;
    }
    startProgress();
    ApiChecker.checkApi(response);
    _contextPopIfAvailable();
  }

  void _contextPopIfAvailable() {
    BuildContext? context = rootNavigator.currentContext;
    if (context != null && context.mounted && context.canPop()) {
      context.pop();
    }
  }
}

final getUserProfileProvider = FutureProvider<UserResponse>((ref) async {
  var repo = ref.read(authRepoProvider);

  Response response = await repo.getUserProfile();

  if (response.statusCode == 200) {
    return UserResponse.fromJson(jsonDecode(response.body)['data']['user_data']);
  } else if (response.statusCode == 401) {
    throw ResponseError(response.statusCode, 'Unauthenticated');
  } else {
    try {
      dynamic body = jsonDecode(response.body);
      ErrorResponse error = ErrorResponse.fromJson(body);
      String errorMessage = error.message ?? AppConstants.WENT_WRONG;
      throw ResponseError(response.statusCode, errorMessage);
    } catch (e) {
      throw ResponseError(response.statusCode, AppConstants.WENT_WRONG);
    }
  }
});
