class NotificationResponse {
  bool? status;
  String? message;
  Data? data;

  NotificationResponse({this.status, this.message, this.data});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<NotificationData>? notificationData;

  Data({this.notificationData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notification_data'] != null) {
      notificationData = <NotificationData>[];
      json['notification_data'].forEach((v) {
        notificationData!.add(new NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notificationData != null) {
      data['notification_data'] =
          this.notificationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  int? id;
  int? senderId;
  int? receiverId;
  String? title;
  String? type;
  String? message;
  String? data;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? date;
  String? image;

  NotificationData(
      {this.id,
        this.senderId,
        this.receiverId,
        this.title,
        this.type,
        this.message,
        this.data,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.date,
        this.image});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    title = json['title'];
    type = json['type'];
    message = json['message'];
    data = json['data'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    date = json['date'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['title'] = this.title;
    data['type'] = this.type;
    data['message'] = this.message;
    data['data'] = this.data;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['date'] = this.date;
    data['image'] = this.image;
    return data;
  }
}