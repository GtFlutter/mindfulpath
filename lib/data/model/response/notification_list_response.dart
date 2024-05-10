import 'package:meditation_app/data/model/response/category_list_reponse.dart';

class NotificationListResponse {
  bool? status;
  String? message;
  Data? data;

  NotificationListResponse({this.status, this.message, this.data});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
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
  List<int>? purchaseCategoryData;

  Data({this.notificationData, this.purchaseCategoryData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notification_data'] != null) {
      notificationData = <NotificationData>[];
      json['notification_data'].forEach((v) {
        notificationData!.add(new NotificationData.fromJson(v));
      });
    }
    purchaseCategoryData = json['purchase_category_data'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notificationData != null) {
      data['notification_data'] =
          this.notificationData!.map((v) => v.toJson()).toList();
    }
    data['purchase_category_data'] = this.purchaseCategoryData;
    return data;
  }
}

class NotificationData {
  int? id;
  int? senderId;
  int? receiverId;
  String? title;
  String? type;
  String? itemId;
  String? message;
  int? status;
  String? createdAt;
  String? updatedAt;
  ItmData? itmData;
  CategoryListResponse? catData;
  String? date;
  String? image;

  NotificationData(
      {this.id,
        this.senderId,
        this.receiverId,
        this.title,
        this.type,
        this.itemId,
        this.message,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.itmData,
        this.catData,
        this.date,
        this.image});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    title = json['title'];
    type = json['type'];
    itemId = json['item_id'];
    message = json['message'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itmData = json['itm_data'] != null
        ? new ItmData.fromJson(json['itm_data'])
        : null;
    catData = json['cat_data'] != null
        ? new CategoryListResponse.fromJson(json['cat_data'])
        : null;
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
    data['item_id'] = this.itemId;
    data['message'] = this.message;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.itmData != null) {
      data['itm_data'] = this.itmData!.toJson();
    }
    if (this.catData != null) {
      data['cat_data'] = this.catData!.toJson();
    }
    data['date'] = this.date;
    data['image'] = this.image;
    return data;
  }
}

class ItmData {
  int? id;
  String? title;
  int? categoryId;
  String? uniqueId;
  int? canViewFreeUser;
  int? pdfType;
  String? createdAt;
  String? updatedAt;
  String? thumbnailImageUrl;
  String? pdfUrl;
  Image? image;
  Item? pdf;
  String? duration;
  String? isFeatured;
  int? videoType;
  String? videoUrl;
  Item? video;
  String? buttonTitle;
  String? price;

  ItmData(
      {this.id,
        this.title,
        this.categoryId,
        this.uniqueId,
        this.canViewFreeUser,
        this.pdfType,
        this.createdAt,
        this.updatedAt,
        this.thumbnailImageUrl,
        this.pdfUrl,
        this.image,
        this.pdf,
        this.duration,
        this.isFeatured,
        this.videoType,
        this.videoUrl,
        this.video,
        this.buttonTitle,
        this.price});

  ItmData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    categoryId = json['category_id'];
    uniqueId = json['unique_id'];
    canViewFreeUser = json['can_view_free_user'];
    pdfType = json['pdf_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnailImageUrl = json['thumbnail_image_url'];
    pdfUrl = json['pdf_url'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    pdf = json['pdf'] != null ? new Item.fromJson(json['pdf']) : null;
    duration = json['duration'];
    isFeatured = json['is_featured'];
    videoType = json['video_type'];
    videoUrl = json['video_url'];
    video = json['video'] != null ? new Item.fromJson(json['video']) : null;
    buttonTitle = json['button_title'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['category_id'] = this.categoryId;
    data['unique_id'] = this.uniqueId;
    data['can_view_free_user'] = this.canViewFreeUser;
    data['pdf_type'] = this.pdfType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['thumbnail_image_url'] = this.thumbnailImageUrl;
    data['pdf_url'] = this.pdfUrl;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    if (this.pdf != null) {
      data['pdf'] = this.pdf!.toJson();
    }
    data['duration'] = this.duration;
    data['is_featured'] = this.isFeatured;
    data['video_type'] = this.videoType;
    data['video_url'] = this.videoUrl;
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    data['button_title'] = this.buttonTitle;
    data['price'] = this.price;
    return data;
  }
}

class Item {
  int? id;
  String? typeId;
  String? fileName;
  String? type;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  Item(
      {this.id,
        this.typeId,
        this.fileName,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.imageUrl});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['type_id'];
    fileName = json['file_name'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_id'] = this.typeId;
    data['file_name'] = this.fileName;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class CatData {
  int? id;
  String? title;
  String? buttonTitle;
  String? price;
  String? createdAt;
  String? updatedAt;
  Image? image;

  CatData(
      {this.id,
        this.title,
        this.buttonTitle,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.image});

  CatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    buttonTitle = json['button_title'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['button_title'] = this.buttonTitle;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class Image {
  int? id;
  String? typeId;
  String? fileName;
  String? type;
  String? imageUrl;

  Image({this.id, this.typeId, this.fileName, this.type, this.imageUrl});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['type_id'];
    fileName = json['file_name'];
    type = json['type'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_id'] = this.typeId;
    data['file_name'] = this.fileName;
    data['type'] = this.type;
    data['image_url'] = this.imageUrl;
    return data;
  }
}


