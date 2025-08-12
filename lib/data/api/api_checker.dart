import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meditation_app/provider/auth_provider.dart';

import '../../ui/common/custom_snackbar.dart';
import '../model/response/error_res_model.dart';

class ApiChecker {
  static void checkApi(http.Response response, {AuthNotifier? authNotifier}) {
    debugPrint('Response StatusCode--${response.statusCode}');
    if (response.statusCode == 401 || response.statusCode == 400) {
      // TODO : Logout User
      debugPrint('Response StatusCode 401 Logout User');
      if (authNotifier != null) {
        authNotifier.logoutUser();
      }
    } else {
      try {
        dynamic body = jsonDecode(response.body);
        ErrorResponse error = ErrorResponse.fromJson(body);
        if (error.message != null && error.message!.isNotEmpty) showCustomSnackBar(error.message!, type: false);
      } catch (e) {
        showCustomSnackBar(e.toString(), type: false);
      }
    }
  }
}
