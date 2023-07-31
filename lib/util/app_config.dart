// ignore_for_file: constant_identifier_names

class AppConfigs {
  static const String APP_NAME = 'Meditation';
  static const String baseUrl = 'https://gurutechnolabs.co.in/website/laravel/meditation/public/api';

  /// For [registerUser] and [forgotPassword]
  static const String sendOTP = '/send-otp';
  static const String verifyOTP = '/verify-otp';
  static const String register = '/register';
  static const String login = '/login';

  /// Shared Key
  static const String TOKEN = 'meditation_token';
}
