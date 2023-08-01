class NewUserResponseErrorModel {
  final List<String> name;
  final List<String> email;
  final List<String> phoneNo;
  final List<String> birthDate;
  final List<String> gender;
  final List<String> password;

  NewUserResponseErrorModel({required this.name, required this.email, required this.phoneNo, required this.birthDate, required this.gender, required this.password,});

  factory NewUserResponseErrorModel.fromJson(Map<String, dynamic> json) {
    return NewUserResponseErrorModel(
      name: json['name'] == null ? [] : json['name'].cast<String>(),
      email: json['email'] == null ? [] : json['email'].cast<String>(),
      phoneNo: json['phone_no'] == null ? [] : json['phone_no'].cast<String>(),
      birthDate: json['birth_date'] == null ? [] : json['birth_date'].cast<String>(),
      gender: json['gender'] == null ? [] : json['gender'].cast<String>(),
      password: json['password'] == null ? [] : json['password'].cast<String>(),
    );
  }
}
