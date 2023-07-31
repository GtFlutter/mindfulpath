import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/data/model/body/create_user_profile_model.dart';
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

  Future<Response> createUserProfile(CreateUserProfileModel model) async {
    return await apiClient.postData(AppConfigs.register, model.toMap);
  }

  Future<Response> loginUser(String phoneNo, String password) async {
    return await apiClient.postData(AppConfigs.login, {'phone_no': phoneNo, 'password': password});
  }
}
