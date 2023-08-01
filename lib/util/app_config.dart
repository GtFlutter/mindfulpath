// ignore_for_file: constant_identifier_names

// TODO : Resend OTP Pending For All Like Registeration and Forgot Password etc
class AppConfigs {
  static const String APP_NAME = 'Meditation';
  static const String baseUrl = 'https://gurutechnolabs.co.in/website/laravel/meditation/public/api';

  /// For [registerUser] and [forgotPassword]
  static const String sendOTP = '/send-otp';
  static const String verifyOTP = '/verify-otp';
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/log-out';

  /// Forgot Password : Only OTP Verification Require, No Auth Require
  static const String resetPassword = '/reset-password';

  /// Shared Key
  static const String TOKEN = 'meditation_token';
}
