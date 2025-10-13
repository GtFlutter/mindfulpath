class CheckSocialUserResponse {
  bool? status;
  String? message;
  CheckSocialUserData? data;

  CheckSocialUserResponse({this.status, this.message, this.data});

  CheckSocialUserResponse.fromJson(dynamic json) {
    status = json['status'].toString().toLowerCase() == true.toString().toLowerCase();
    message = json['message'];
    if (json['data'] != null) data = CheckSocialUserData.fromJson(json['data']);
  }
}

class CheckSocialUserData {
  String? socialId;
  String? token;
  int? userId;
  bool? userPhotoExits;
  CheckSocialUserData({this.socialId, this.token, this.userId, this.userPhotoExits});

  CheckSocialUserData.fromJson(dynamic json) {
    socialId = json['social_id'];
    if (json['token'] != null) token = json['token'];
    if (json['user_id'] != null) userId = json['user_id'];
    userPhotoExits = json['user_photo_exits'];
  }
}


class CheckSocialUserRequest {
  String? socialId;
  String? email;
  String? fcmToken;

  CheckSocialUserRequest({this.socialId, this.email, this.fcmToken});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (socialId != null) map.update('social_id', (value) => socialId, ifAbsent: () => socialId,);
    if (fcmToken != null) map.update('fcm_token', (value) => fcmToken, ifAbsent: () => fcmToken,);
    if (email != null) map.update('email', (value) => email, ifAbsent: () => email,);
    return map;
  }
}



class SocialUserData {
  String? userName;
  String? socialId;
  String? mobileOrEmail;
  String? fcmToken;
  bool isSocialLogin;
  bool isGoogleLogin;
  bool isAppleLogin;

  SocialUserData({this.userName, this.socialId, this.mobileOrEmail, this.fcmToken, this.isSocialLogin = false, this.isGoogleLogin = false, this.isAppleLogin = false});
}