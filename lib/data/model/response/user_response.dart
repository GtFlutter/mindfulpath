class UserResponse {
  int? id;
  String? name;
  String? email;
  String? phoneNo;
  DateTime? birthDate;
  String? gender;
  int? status;
  DateTime? emailVerifiedAt;
  int? isNotificationMute;
  String? fcmToken;
  String? userType;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserResponse({
    this.id,
    this.name,
    this.email,
    this.phoneNo,
    this.birthDate,
    this.gender,
    this.status,
    this.emailVerifiedAt,
    this.isNotificationMute,
    this.fcmToken,
    this.userType,
    this.createdAt,
    this.updatedAt,
  });

  UserResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    phoneNo = json['phone_no'] as String?;
    birthDate = json['birth_date'] == null ? null : DateTime.parse(json['birth_date'] as String);
    gender = json['gender'] as String?;
    status = json['status'] as int?;
    emailVerifiedAt = json['email_verified_at'] == null ? null : DateTime.parse(json['email_verified_at'] as String);
    isNotificationMute = json['is_notification_mute'] as int?;
    fcmToken = json['fcm_token'] as String?;
    userType = json['user_type'] as String?;
    createdAt = json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String);
    updatedAt = json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String);
  }
}
