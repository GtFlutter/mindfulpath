/// {
///   "id": 1,
///   "title": "test1",
///   "button_title": "test1",
///   "image": {
///     "id": 1,
///     "type_id": "1",
///     "file_name": "Category_1_95077.jpg",
///     "type": "category_image",
///     "image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/category_image/Category_1_95077.jpg"
///   }
/// },
library;

class CategoryListResponse {
  int? id;
  String? title;
  String? buttonTitle;
  String? price;
  bool? isPurchased;
  String? createdAt;
  String? updatedAt;
  CategoryImageResponse? imageResponse;

  CategoryListResponse({this.id, this.title, this.buttonTitle, this.price, this.isPurchased, this.createdAt, this.updatedAt, this.imageResponse});

  factory CategoryListResponse.fromJson(dynamic json) {
    return CategoryListResponse(
      id: json['id'],
      title: json['title'],
      buttonTitle: json['button_title'],
      price: json['price'],
      isPurchased: json['is_purchased'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      imageResponse: json['image'] != null ? CategoryImageResponse.fromJson(json['image']) : null,
    );
  }

  static List<CategoryListResponse> listFromJson(List<dynamic> listJson) {
    List<CategoryListResponse> list = [];
    for (var json in listJson) {
      list.add(CategoryListResponse.fromJson(json));
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['button_title'] = buttonTitle;
    data['image'] = imageResponse?.toJson();
    return data;
  }

  CategoryListResponse copyWith({
    int? id,
    String? title,
    String? buttonTitle,
    String? price,
    bool? isPurchased,
    String? createdAt,
    String? updatedAt,
    CategoryImageResponse? imageResponse,
  }) =>
      CategoryListResponse(
          id:id ?? this.id,
          title:title ?? this.title,
          buttonTitle:buttonTitle ?? this.buttonTitle,
          price:price ?? this.price,
          isPurchased:isPurchased ?? this.isPurchased,
          createdAt:createdAt ?? this.createdAt,
          updatedAt:updatedAt ?? this.updatedAt,
          imageResponse:imageResponse ?? this.imageResponse,
      );

  Map<String, dynamic> toJsonData() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['button_title'] = buttonTitle;
    data['price'] = buttonTitle;
    data['is_purchased'] = buttonTitle;
    data['image'] = imageResponse?.toJson();
    return data;
  }
}


class CategoryImageResponse {
  int? id;
  String? typeId;
  String? fileName;
  String? type;
  String? imageUrl;

  CategoryImageResponse({this.id, this.typeId, this.fileName, this.type, this.imageUrl});

  CategoryImageResponse.fromJson(dynamic json) {
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
