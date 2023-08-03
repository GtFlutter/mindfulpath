class StaticData {
  int? id;
  String? title;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  StaticData({this.id, this.title, this.key, this.value, this.createdAt, this.updatedAt});

  factory StaticData.fromJson(Map<String, dynamic> json) {
    return StaticData(
      id: json['id'],
      title: json['title'],
      key: json['key'],
      value: json['value'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
