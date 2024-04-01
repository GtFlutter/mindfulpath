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
    return await apiClient.postData(AppConfigs.registerUser, model.toJson);
  }

  Future<Response> updateUserProfile(UserBody model) async {
    return await apiClient.postData(AppConfigs.updateUserProfile, model.toJson);
  }

  Future<Response> loginUser(String phoneNo, String password,String fcmToken) async {
    return await apiClient
        .postData(AppConfigs.loginUser, {'phone_no': phoneNo, 'password': password, 'fcm_token': fcmToken});
  }

  Future<Response> logoutUser() async {
    return await apiClient.getData(AppConfigs.logoutUser);
  }

  Future<Response> getUserProfile() async {
    return await apiClient.getData(AppConfigs.getUserProfile);
  }

  /// Forgot Password : Only OTP Verification Require, No Auth Require
  Future<Response> resetPassword(String phoneNo, String password) async {
    return await apiClient.postData(AppConfigs.resetPassword, {'phone_no': phoneNo, 'password': password});
  }

  Future<Response> changePassword(String oldPassword, String password) async {
    return await apiClient.postData(AppConfigs.changePassword, {'old_password': oldPassword, 'new_password': password});
  }

  Future<bool> saveUserToken(String token) async {
    debugPrint(' New Token :::: $token');
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConfigs.TOKEN, token);
  }

  Future<bool> clearUserData() async {
    debugPrint(' Clearing User Token');
    apiClient.token = null;
    apiClient.updateHeader(null);
    return sharedPreferences.clear();
  }

  String? get getUserToken {
    if (sharedPreferences.containsKey(AppConfigs.TOKEN)) {
      return sharedPreferences.getString(AppConfigs.TOKEN);
    }
    return null;
  }

  bool get isUserLoggedIn => getUserToken != null;
}
