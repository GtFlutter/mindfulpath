class ScreenPaths {
  static const String splash = '/';

  /// Sign Up and Sign In Flow
  static const String signInUp = '/sign-in-up';
  static const String otpVerificationScreen = '/otp-verification';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String createNewPasswordScreen = '/create-new-password';
  static const String createNewProfileScreen = '/create-new-profile';

  /// Settings Flow
  static const String tCPpScreen = '/tc-pp';

  ///
  static const String libraryScreen = '/library';
  static const String coursesListScreen = 'courses-list';
  static const String coursesListScreenPath = '$libraryScreen/$coursesListScreen';

  ///
  static const String discoverScreen = '/discover';
  // [detail-category]
  static const String detailCategoryScreen = 'detail-category';
  static const String detailCategoryScreenPath = '$discoverScreen/$detailCategoryScreen';
  // [Profile]
  static const String profileScreen = 'profile';
  static const String profileScreenPath = '$discoverScreen/$profileScreen';
  // [Edit Profile]
  static const String editProfileScreen = 'edit-profile';
  static const String editProfileScreenPath = '$discoverScreen/$profileScreen/$editProfileScreen';

  ///
  static const String analyticsScreen = '/analytics';
}
