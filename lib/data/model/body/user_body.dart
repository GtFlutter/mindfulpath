// name:Ankur
// email:ankur.gurutechnolabs1@gmail.com
// phone_no:+919727308286
// birth_date:2000-06-15
// gender:male
// password:Ankur@123

import 'package:meditation_app/helper/date_converter.dart';

class UserBody {
  final String name;
  final String email;
  final String? phoneNo;
  final DateTime birthDate;
  final String gender;
  final String? password;
  final String fcmToken;
  String? googleId;
  String? facebookId;

  UserBody.register(this.name, this.email, this.phoneNo, this.birthDate, this.gender, this.password, this.fcmToken, {this.googleId, this.facebookId});

  UserBody.update(
    this.name,
    this.email,
    this.phoneNo,
    this.birthDate,
    this.gender,
  )   : password = '',
        fcmToken = '';

  Map<String, String> get toJson {
    return {
      'name': name.trim(),
      'email': email.trim(),
      if(phoneNo?.isNotEmpty ?? false)'phone_no': phoneNo?.trim() ?? "",
      'birth_date': birthDate.toStringFormat3.trim(),
      'gender': gender.trim().toLowerCase(),
      if(googleId?.isNotEmpty ?? false)'google_id': googleId?.trim().toLowerCase() ?? "",
      if(facebookId?.isNotEmpty ?? false)'facebookId': facebookId?.trim().toLowerCase() ?? "",
      if (password?.trim().isNotEmpty ?? false) 'password': password?.trim() ?? "",
      if (fcmToken.trim().isNotEmpty) 'fcm_token': fcmToken.trim(),
    };
  }
}
