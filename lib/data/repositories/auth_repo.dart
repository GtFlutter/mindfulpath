import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/data/model/body/user_body.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SendOTP {
  register('register'),
  forgotPwd('forgot_pwd');

  final String value;
  const SendOTP(this.value);
}

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> requestOTP(String phoneNo, SendOTP type) async {
    return await apiClient.postData(
      AppConfigs.sendOTP,
      {'phone_no': phoneNo, 'type': type.value},
    );
  }

  Future<Response> verifyOTP(String phoneNo, int otp) async {
    return await apiClient.postData(
      AppConfigs.verifyOTP,
      {'phone_no': phoneNo, 'otp': otp},
    );
  }

  Future<Response> createUserProfile(UserBody model) async {
    return await apiClient.postData(AppConfigs.register, model.toMap);
  }

  Future<Response> updateUserProfile(UserBody model) async {
    return await apiClient.postData(AppConfigs.updateProfile, model.toMap);
  }

  Future<Response> loginUser(String phoneNo, String password) async {
    return await apiClient.postData(AppConfigs.login, {'phone_no': phoneNo, 'password': password});
  }

  Future<Response> logoutUser() async {
    return await apiClient.getData(AppConfigs.logout);
  }

  Future<Response> getUserProfile() async {
    return await apiClient.getData(AppConfigs.userProfile);
  }

  /// Forgot Password : Only OTP Verification Require, No Auth Require
  Future<Response> resetPassword(String phoneNo, String password) async {
    return await apiClient.postData(AppConfigs.resetPassword, {'phone_no': phoneNo, 'password': password});
  }

  Future<Response> changePassword(String oldPassword, String password) async {
    return await apiClient.postData(AppConfigs.changePassword, {'old_password': oldPassword, 'new_password': password});
  }

  Future<Response> getStaticPage() async {
    return await apiClient.getData(AppConfigs.getStaticPage);
  }

  Future<bool> saveUserToken(String token) async {
    debugPrint('Yashvant New Token :::: $token');
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConfigs.TOKEN, token);
  }

  Future<bool> clearUserData() async {
    debugPrint('Yashvant Clearing User Token');
    apiClient.token = null;
    apiClient.updateHeader(null);
    return sharedPreferences.clear();
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConfigs.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConfigs.TOKEN);
  }
}
