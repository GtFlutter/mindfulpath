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

class CategoryListResponse {
  final int? id;
  final String? title;
  final String? buttonTitle;
  final CategoryImageResponse? imageResponse;

  const CategoryListResponse({this.id, this.title, this.buttonTitle, this.imageResponse});

  factory CategoryListResponse.fromJson(dynamic json) {
    return CategoryListResponse(
      id: json['id'],
      title: json['title'],
      buttonTitle: json['button_title'],
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
}
