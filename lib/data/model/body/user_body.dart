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
  final String phoneNo;
  final DateTime birthDate;
  final String gender;
  final String password;

  UserBody.register(
    this.name,
    this.email,
    this.phoneNo,
    this.birthDate,
    this.gender,
    this.password,
  );

  UserBody.update(
    this.name,
    this.email,
    this.phoneNo,
    this.birthDate,
    this.gender,
  ) : password = '';

  Map<String, String> get toMap {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'phone_no': phoneNo.trim(),
      'birth_date': birthDate.toStringFormat3.trim(),
      'gender': gender.trim().toLowerCase(),
      if (password.trim().isNotEmpty) 'password': password.trim(),
    };
  }
}
