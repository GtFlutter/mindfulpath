// ignore_for_file: constant_identifier_names

// TODO : Resend OTP Pending For All Like Registeration and Forgot Password etc
class AppConfigs {
  /// START [API_CONFIG]

  static const String APP_NAME = 'Meditation';
  static const String baseUrl = 'https://themindfulpath.com/api';

  /// [User_Authentication]
  // User Before For [registerUser] and [forgotPassword]
  static const String sendOTP = '/send-otp';
  static const String verifyOTP = '/verify-otp';
  static const String registerUser = '/register';
  static const String loginUser = '/login';
  static const String logoutUser = '/log-out';
  static const String getUserProfile = '/get-user-profile';
  static const String updateUserProfile = '/update-profile';
  static const String checkSocialUser = '/check-social-user';
  // For Forgot Password : Only OTP Verification Require, No Auth Require
  // Do OTP Verification via [sendOTP] and then [verifyOTP]
  static const String resetPassword = '/reset-password';
  // For Chanage Password : Auth Require
  static const String changePassword = '/update-password';

  /// [Settings]
  // Get All View Data Example List Of Privacy Policy, Terms & Conditions,
  // share_ios_link, share_android_link etc.
  static const String getStaticPageData = '/get-static-page';
  static const String raiseSupportTicket = '/contact-support';
  static const String getSupportTicketsList = '/contact-support-list';
  static const String notificationToggle = '/notification-setting';

  static const String getCategoryList = '/get-category-list';
  static const String getVideos = '/get-video-list';
  static const String getPdfs = '/get-pdf-list';
  static const String storeWatchedVideoDuration = '/store-watched-video-duration';
  static const String getFeatureVideoList = '/get-featured-video-list';
  static const String searchVideos = '/search-video';
  static const String purchaseSubscription = '/purchase-subscription';
  static const String getAudios = '/get-audio-list';
  static const String getAllItem = '/get-all-list';


  static const String getBookmarks = '/get-bookmark-list';
  static const String getAudioBookmarks = '/get-audio-bookmark-list';
  static const String getPDFBookmarks = '/get-pdf-bookmark-list';
  static const String toggleBookmark = '/add-to-bookmark';

  static const String getPlaylist = '/get-playlist';
  static const String getPlaylistDetail = '/playlist-detail';
  static const String createPlaylist = '/create-playlist';
  static const String deletePlaylist = '/delete-playlist';
  static const String addToPlaylist = '/add-to-playlist';
  static const String removeFromPlaylist = '/remove-from-playlist';

  /// [Analytics]
  static const String getStatistics = '/get-statistics';
  static const String getCategoryNames = '/get-category-name';
  static const String getVideoNames = '/get-video-name';


  static const String getPurchaseList = '/get-purchase-list';
  static const String getCurrentlyProgressList = '/get-currently-progress';

  static const String getNotification = '/get-notification-list';
  static const String getReadNotification = '/notification-read';

  /// END [API_CONFIG]

  /// START [LOCAL_KEY]

  // Shared Preference Key
  static const String TOKEN = 'meditation_token';
  static const String RECENT_VIDEOS = 'recent_videos';

  /// END [LOCAL_KEY]
}
