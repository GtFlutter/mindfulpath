import 'package:meditation_app/data/model/response/category_list_reponse.dart';

class NotificationListResponse {
  bool? status;
  String? message;
  Data? data;

  NotificationListResponse({this.status, this.message, this.data});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
        notificationData!.add(NotificationData.fromJson(v));
      });
    }
    purchaseCategoryData = json['purchase_category_data'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notificationData != null) {
      data['notification_data'] =
          notificationData!.map((v) => v.toJson()).toList();
    }
    data['purchase_category_data'] = purchaseCategoryData;
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
        ? ItmData.fromJson(json['itm_data'])
        : null;
    catData = json['cat_data'] != null
        ? CategoryListResponse.fromJson(json['cat_data'])
        : null;
    date = json['date'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['title'] = title;
    data['type'] = type;
    data['item_id'] = itemId;
    data['message'] = message;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (itmData != null) {
      data['itm_data'] = itmData!.toJson();
    }
    if (catData != null) {
      data['cat_data'] = catData!.toJson();
    }
    data['date'] = date;
    data['image'] = image;
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
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    pdf = json['pdf'] != null ? Item.fromJson(json['pdf']) : null;
    duration = json['duration'];
    isFeatured = json['is_featured'];
    videoType = json['video_type'];
    videoUrl = json['video_url'];
    video = json['video'] != null ? Item.fromJson(json['video']) : null;
    buttonTitle = json['button_title'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['category_id'] = categoryId;
    data['unique_id'] = uniqueId;
    data['can_view_free_user'] = canViewFreeUser;
    data['pdf_type'] = pdfType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['thumbnail_image_url'] = thumbnailImageUrl;
    data['pdf_url'] = pdfUrl;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    if (pdf != null) {
      data['pdf'] = pdf!.toJson();
    }
    data['duration'] = duration;
    data['is_featured'] = isFeatured;
    data['video_type'] = videoType;
    data['video_url'] = videoUrl;
    if (video != null) {
      data['video'] = video!.toJson();
    }
    data['button_title'] = buttonTitle;
    data['price'] = price;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type_id'] = typeId;
    data['file_name'] = fileName;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
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
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['button_title'] = buttonTitle;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (image != null) {
      data['image'] = image!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type_id'] = typeId;
    data['file_name'] = fileName;
    data['type'] = type;
    data['image_url'] = imageUrl;
    return data;
  }
}


