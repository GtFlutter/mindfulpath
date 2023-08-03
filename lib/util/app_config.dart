// ignore_for_file: constant_identifier_names

// TODO : Resend OTP Pending For All Like Registeration and Forgot Password etc
class AppConfigs {
  static const String APP_NAME = 'Meditation';
  static const String baseUrl = 'https://gurutechnolabs.co.in/website/laravel/meditation/public/api';

  /// For [register] and [forgotPassword]
  static const String sendOTP = '/send-otp';
  static const String verifyOTP = '/verify-otp';
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/log-out';

  /// Forgot Password : Only OTP Verification Require, No Auth Require
  static const String resetPassword = '/reset-password';

  /// Chanage Password : Auth Require
  static const String changePassword = '/update-password';
  static const String userProfile = '/get-user-profile';
  static const String updateProfile = '/update-profile';

  /// Get All View Data Example List Of Privacy Policy, Terms & Conditions, share_ios_link, share_android_link etc.
  static const String getStaticPage = '/get-static-page';

  /// Shared Key
  static const String TOKEN = 'meditation_token';
}
