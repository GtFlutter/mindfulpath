class CategoryModal {
  int? id;
  String? categoryId;
  String? categoryName;
  String? categoryImage;

  CategoryModal({this.id, this.categoryId, this.categoryName, this.categoryImage});

  CategoryModal.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryImage = json['category_image'];
  }

  Map<String, String> toJson() {
    Map<String, String> map = {};
    map['category_id'] = categoryId!;
    map['category_name'] = categoryName!;
    map['category_image'] = categoryImage!;
    return map;
  }
}

class VideoModal {
  int? id;
  int? categoryId;
  String? videoId;
  String? videoName;
  String? videoFile;

  VideoModal({this.id, this.categoryId, this.videoId, this.videoName, this.videoFile});

  VideoModal.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    videoId = json['video_id'];
    videoName = json['video_name'];
    videoFile = json['video_file'];
  }

  Map<String, String> toJson() {
    Map<String, String> map = {};
    map['category_id'] = categoryId.toString();
    map['video_id'] = videoId!;
    map['video_name'] = videoName!;
    map['video_file'] = videoFile!;
    return map;
  }
}