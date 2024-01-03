/// {
///   "id": 1,
///   "user_id": 3,
///   "category_id": 2,
///   "title": "Ketogenic",
///   "price": "",
///   "created_at": "2023-12-27T07:57:50.000000Z",
///   "updated_at": "2023-12-27T07:57:50.000000Z",
///   "category": {
///       "id": 2,
///       "title": "Ketogenic",
///       "button_title": "Diet",
///       "price": "",
///       "created_at": "2023-08-09T11:48:23.000000Z",
///       "updated_at": "2023-08-16T05:46:01.000000Z",
///       "image": {
///           "id": 13,
///           "type_id": "2",
///           "file_name": "Category_2_85140.jpg",
///           "type": "category_image",
///           "image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/category_image/Category_2_85140.jpg"
///       }
///   }
/// }
library;

import 'package:meditation_app/data/model/response/category_list_reponse.dart';

class PurchasedVideoResponse {
  final num? id;
  final num? userId;
  final num? categoryId;
  final String? title;
  final String? price;
  final String? createdAt;
  final String? updatedAt;
  final CategoryListResponse? categoryResponse;

  PurchasedVideoResponse({this.id, this.userId, this.categoryId, this.title, this.price, this.createdAt, this.updatedAt, this.categoryResponse});

  factory PurchasedVideoResponse.fromJson(dynamic json) {
    return PurchasedVideoResponse(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      title: json['title'],
      price: json['price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryResponse: json['category'] == null ? null : CategoryListResponse.fromJson(json['category']),
    );
  }

  static List<PurchasedVideoResponse> listFromJson(dynamic jsonList) {
    List<PurchasedVideoResponse> list = [];
    for (var json in jsonList) {
      list.add(PurchasedVideoResponse.fromJson(json));
    }
    return list;
  }
}