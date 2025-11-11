import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/repositories/auth_repo.dart';
import 'package:meditation_app/provider/repo_provider/auth_repo_provider.dart';

import '../data/model/response/error_res_model.dart';
import '../helper/route/router.dart';
import '../ui/common/custom_snackbar.dart';
import '../util/constants.dart';

final changePasswordProvider = Provider<ChangePasswordNotifier>((ref) {
  final repo = ref.watch(authRepoProvider);
  return ChangePasswordNotifier(repo);
});

class ChangePasswordNotifier extends ChangeNotifier {
  final AuthRepo repo;

  ChangePasswordNotifier(this.repo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _oldPwdErrorText;
  String? _newPwdErrorText;
  String? _commonErrorText;

  String? get oldPwdErrorText => _oldPwdErrorText;
  String? get newPwdErrorText => _newPwdErrorText;
  String? get commonErrorText => _commonErrorText;

  void clearAllErrorText({bool notifie = true}) {
    _oldPwdErrorText = null;
    _newPwdErrorText = null;
    _commonErrorText = null;
    if (notifie) notifyListeners();
  }

  void setOldPwdError({String? error, bool notifie = true}) {
    if (error == null && _oldPwdErrorText == null) {
      if (_commonErrorText != null) {
        _commonErrorText = null;
        if (notifie) notifyListeners();
      }
      return;
    }
    if (_commonErrorText != null) {
      _commonErrorText = null;
    }
    _oldPwdErrorText = error;
    if (notifie) notifyListeners();
  }

  void setNewPwdError({String? error, bool notifie = true}) {
    if (error == null && _newPwdErrorText == null) {
      if (_commonErrorText != null) {
        _commonErrorText = null;
        if (notifie) notifyListeners();
      }
      return;
    }
    if (_commonErrorText != null) {
      _commonErrorText = null;
    }
    _newPwdErrorText = error;
    if (notifie) notifyListeners();
  }

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

  Future<void> changePassword(String oldPassword, String newPassword) async {
    startProgress();
    Response response = await repo.changePassword(oldPassword, newPassword);
    if (response.statusCode == 200) {
      stopProgress();
      showCustomSnackBar('Password Changed Successfully', type: true);
      _contextPopIfAvailable();
      return;
    }
    if (response.statusCode == 403 && jsonDecode(response.body)['data'] != null) {
      ChangePwdResponseErrorModel errorModel = ChangePwdResponseErrorModel.fromJson(jsonDecode(response.body)['data']);
      if (errorModel.oldPassword.isNotEmpty) setOldPwdError(error: errorModel.oldPassword.first, notifie: false);
      if (errorModel.newPassword.isNotEmpty) setNewPwdError(error: errorModel.newPassword.first, notifie: false);
      stopProgress();
      return;
    }
    if (response.statusCode == 401) {
      _commonErrorText = 'Unauthorized access';
    } else {
      try {
        dynamic body = jsonDecode(response.body);
        ErrorResponse error = ErrorResponse.fromJson(body);
        if (error.message != null && error.message!.isNotEmpty) {
          _commonErrorText = error.message!;
        } else {
          _commonErrorText = AppConstants.WENT_WRONG;
        }
      } catch (e) {
        _commonErrorText = e.toString();
      }
    }
    stopProgress();
  }

  void _contextPopIfAvailable() {
    BuildContext? context = rootNavigator.currentContext;
    if (context != null && context.mounted && context.canPop()) {
      context.pop();
    }
  }
}

class ChangePwdResponseErrorModel {
  final List<String> oldPassword;
  final List<String> newPassword;

  ChangePwdResponseErrorModel({
    required this.oldPassword,
    required this.newPassword,
  });

  factory ChangePwdResponseErrorModel.fromJson(Map<String, dynamic> json) {
    return ChangePwdResponseErrorModel(
      oldPassword: json['old_password'] == null ? [] : List<String>.from(json['old_password']),
      newPassword: json['new_password'] == null ? [] : List<String>.from(json['new_password']),
    );
  }
}
