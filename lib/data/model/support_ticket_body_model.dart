// This Model Use For Both Body And as a Model

class SupportTicket {
  final int? id;
  final int? userId;
  final String? name;
  final String? email;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SupportTicket.body({
    required String this.name,
    required String this.email,
    required String this.description,
  })  : id = null,
        userId = null,
        createdAt = null,
        updatedAt = null;

  SupportTicket.model({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket.model(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        description: json['description'] as String?,
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String));
  }

  ///  [toJson] only For Raise new ticket
  Map<String, dynamic> get toJson => {
        'name': name,
        'email': email,
        'description': description,
      };

  static List<SupportTicket> listFromJson(List<dynamic> listJson) {
    List<SupportTicket> list = [];
    for (var json in listJson) {
      list.add(SupportTicket.fromJson(json));
    }
    return list;
  }
}
