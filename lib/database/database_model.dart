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
    map['category_id'] = categoryId??"";
    map['category_name'] = categoryName??"";
    map['category_image'] = categoryImage??"";
    return map;
  }


  static List<CategoryModal> listFromJson(dynamic jsonList) {
    List<CategoryModal> tempList = [];
    for (var json in jsonList) {
      tempList.add(CategoryModal.fromJson(json));
    }
    return tempList;
  }
}

class VideoModal {
  int? id;
  int? categoryId;
  String? videoId;
  String? videoThumbnail;
  String? videoName;
  String? videoFile;
  String? videoDuration;

  VideoModal({this.id, this.categoryId, this.videoId,this.videoThumbnail, this.videoName, this.videoFile, this.videoDuration});

  VideoModal.fromJson(dynamic json) {
    id = json['id'];
    categoryId = int.parse(json['category_id'].toString());
    videoId = json['video_id'];
    videoThumbnail = json['thumbnail_image_url'];
    videoName = json['video_name'];
    videoFile = json['video_file'];
    videoDuration = json['video_duration'];
  }

  Map<String, String> toJson() {
    Map<String, String> map = {};
    map['category_id'] = categoryId.toString();
    map['video_id'] = videoId!;
    map['thumbnail_image_url'] = videoThumbnail ?? "";
    map['video_name'] = videoName!;
    map['video_file'] = videoFile!;
    map['video_duration'] = videoDuration!;
    return map;
  }

  static List<VideoModal> listFromJson(dynamic jsonList) {
    List<VideoModal> tempList = [];
    for (var json in jsonList) {
      tempList.add(VideoModal.fromJson(json));
    }
    return tempList;
  }
}

class PdfModel {
  int? id;
  int? categoryId;
  String? pdfId;
  String? pdfName;
  String? pdfFile;
  String? categoryTitle;

  PdfModel({this.id, this.categoryId, this.pdfId, this.pdfName, this.pdfFile,this.categoryTitle});

  PdfModel.fromJson(dynamic json) {
    id = json['id'];
    categoryId = int.parse(json['category_id'].toString());
    pdfId = json['pdf_id'];
    pdfName = json['pdf_name'];
    pdfFile = json['pdf_file'];
    categoryTitle = json['category_title'];
  }

  Map<String, String> toJson() {
    Map<String, String> map = {};
    map['category_id'] = categoryId.toString();
    map['pdf_id'] = pdfId ?? "";
    map['pdf_name'] = pdfName ?? "";
    map['pdf_file'] = pdfFile ?? "";
    map['category_title'] = categoryTitle ?? "";
    return map;
  }

  static List<PdfModel> listFromJson(dynamic jsonList) {
    List<PdfModel> tempList = [];
    for (var json in jsonList) {
      tempList.add(PdfModel.fromJson(json));
    }
    return tempList;
  }
}