import 'package:meditation_app/data/model/response/category_list_reponse.dart';

class CustomNotificationData {
  String? type;
  PdfData? pdfData;
  CategoryListResponse? catData;

  CustomNotificationData({this.type, this.pdfData, this.catData});

  CustomNotificationData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    pdfData = json['pdf_data'] != null
        ? PdfData.fromJson(json['pdf_data'])
        : null;
    catData = json['cat_data'] != null
        ? CategoryListResponse.fromJson(json['cat_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (pdfData != null) {
      data['pdf_data'] = pdfData!.toJson();
    }
    if (catData != null) {
      data['cat_data'] = catData!.toJson();
    }
    return data;
  }
}

class PdfData {
  int? id;
  String? title;
  int? categoryId;
  String? uniqueId;
  int? canViewFreeUser;
  int? pdfType;
  String? createdAt;
  String? updatedAt;
  Null? thumbnailImageUrl;
  String? pdfUrl;
  Null? image;
  Pdf? pdf;

  PdfData(
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
        this.pdf});

  PdfData.fromJson(Map<String, dynamic> json) {
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
    image = json['image'];
    pdf = json['pdf'] != null ? Pdf.fromJson(json['pdf']) : null;
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
    data['image'] = image;
    if (pdf != null) {
      data['pdf'] = pdf!.toJson();
    }
    return data;
  }
}

class Pdf {
  int? id;
  String? typeId;
  String? fileName;
  String? type;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  Pdf(
      {this.id,
        this.typeId,
        this.fileName,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.imageUrl});

  Pdf.fromJson(Map<String, dynamic> json) {
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
