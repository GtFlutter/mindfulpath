import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../ui/common/custom_snackbar.dart';
import '../model/response/error_res_model.dart';

class ApiChecker {
  static void checkApi(http.Response response) {
    if (response.statusCode == 401) {
      // TODO : Logout User
      debugPrint('Response StatusCode 401 Logout User');
      // Get.find<AuthController>().clearSharedData();
      // Get.find<AuthController>().stopLocationRecord();
      // Get.offAllNamed(RouteHelper.getSignInRoute());
    } else {
      try {
        dynamic body = jsonDecode(response.body);
        ErrorResponse error = ErrorResponse.fromJson(body);
        if (error.message != null && error.message!.isNotEmpty) showCustomSnackBar(error.message!);
      } catch (e) {
        showCustomSnackBar(e.toString());
      }
    }
  }
}
