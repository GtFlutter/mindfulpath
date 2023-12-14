class RoutePath {
  static const String splash = '/';

  /// Sign Up and Sign In Flow
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String otpVerificationScreen = '/otp-verification';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String createNewPasswordScreen = '/create-new-password';
  static const String createNewProfileScreen = '/create-new-profile';

  /// Settings Flow
  static const String tCPpScreen = '/tc-pp';

  /// Search Screen
  static const String search = '/search';
  static const String featuredVideoScreen = '/featured-video';

  ///
  static const String libraryScreen = '/library';
  static const String coursesListScreen = 'courses-list';
  static const String coursesListScreenPath = '$libraryScreen/$coursesListScreen';
  static const String subPlaylistScreen = 'sub-play-list';
  static const String subPlaylistScreenPath = '$libraryScreen/$subPlaylistScreen';

  /// [Discover]
  static const String discoverScreen = '/discover';
  //  [detail-category]
  /*  */ static const String detailCategoryScreen = 'detail-category';
  /*  */ static const String detailCategoryScreenPath = '$discoverScreen/$detailCategoryScreen';
  //  [Profile]
  /*  */ static const String profileScreen = 'profile';
  /*  */ static const String profileScreenPath = '$discoverScreen/$profileScreen';
  //         [Edit Profile]
  /*         */ static const String editProfileScreen = 'edit-profile';
  /*         */ static const String editProfileScreenPath = '$discoverScreen/$profileScreen/$editProfileScreen';
  //         [Support]
  /*         */ static const String supportScreen = 'support';
  /*         */ static const String supportScreenPath = '$discoverScreen/$profileScreen/$supportScreen';
  //                [Support-Section]
  /*                */ static const String supportSectionScreen = 'support-section';
  /*                */ static const String supportSectionScreenPath =
      '$discoverScreen/$profileScreen/$supportScreen/$supportSectionScreen';
  //         [Settings]
  /*         */ static const String settingsScreen = 'settings';
  /*         */ static const String settingsScreenPath = '$discoverScreen/$profileScreen/$settingsScreen';
  //         [Notifications]
  /*         */ static const String notifications = 'notifications';
  /*         */ static const String notificationsPath = '$discoverScreen/$profileScreen/$notifications';

  ///
  static const String analyticsScreen = '/analytics';

  // [Base Screen]
  static const String pdfViewer = '/pdf-viewer';
}
