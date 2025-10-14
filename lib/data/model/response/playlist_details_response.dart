import 'package:meditation_app/data/model/response/videos_response.dart';
///new model generate issue
// class PlaylistDetailResponse {
//   bool? status;
//   String? message;
//   Data? data;
//
//   PlaylistDetailResponse({this.status, this.message, this.data});
//
//   PlaylistDetailResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   List<PlaylistVideoList>? playlistVideoList;
//   int? currentPage;
//   int? perPage;
//   int? total;
//   int? lastPage;
//
//   Data(
//       {this.playlistVideoList,
//         this.currentPage,
//         this.perPage,
//         this.total,
//         this.lastPage});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['playlist_video_list'] != null) {
//       playlistVideoList = <PlaylistVideoList>[];
//       json['playlist_video_list'].forEach((v) {
//         playlistVideoList!.add(new PlaylistVideoList.fromJson(v));
//       });
//     }
//     currentPage = json['current_page'];
//     perPage = json['per_page'];
//     total = json['total'];
//     lastPage = json['last_page'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.playlistVideoList != null) {
//       data['playlist_video_list'] =
//           this.playlistVideoList!.map((v) => v.toJson()).toList();
//     }
//     data['current_page'] = this.currentPage;
//     data['per_page'] = this.perPage;
//     data['total'] = this.total;
//     data['last_page'] = this.lastPage;
//     return data;
//   }
// }
//
// class PlaylistVideoList {
//   int? id;
//   int? userId;
//   int? playlistId;
//   int? videoId;
//   String? videoTitle;
//   int? audioId;
//   String? audioTitle;
//   String? createdAt;
//   String? updatedAt;
//   String? categoryTitle;
//   VideoResponse? video;
//   Audio? audio;
//
//   PlaylistVideoList(
//       {this.id,
//         this.userId,
//         this.playlistId,
//         this.videoId,
//         this.videoTitle,
//         this.audioId,
//         this.audioTitle,
//         this.createdAt,
//         this.updatedAt,
//         this.categoryTitle,
//         this.video,
//         this.audio});
//
//   PlaylistVideoList.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     playlistId = json['playlist_id'];
//     videoId = json['video_id'];
//     videoTitle = json['video_title'];
//     audioId = json['audio_id'];
//     audioTitle = json['audio_title'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     categoryTitle = json['category_title'];
//     video = json['video'] != null ? new VideoResponse.fromJson(json['video'],false) : null;
//     audio = json['audio'] != null ? new Audio.fromJson(json['audio']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['playlist_id'] = this.playlistId;
//     data['video_id'] = this.videoId;
//     data['video_title'] = this.videoTitle;
//     data['audio_id'] = this.audioId;
//     data['audio_title'] = this.audioTitle;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['category_title'] = this.categoryTitle;
//     if (this.video != null) {
//       data['video'] = this.video!.toJson();
//     }
//     if (this.audio != null) {
//       data['audio'] = this.audio!.toJson();
//     }
//     return data;
//   }
// }
//
//
//
// class Category {
//   int? id;
//   String? title;
//   String? buttonTitle;
//   String? price;
//   String? createdAt;
//   String? updatedAt;
//   bool? isPurchased;
//
//   Category(
//       {this.id,
//         this.title,
//         this.buttonTitle,
//         this.price,
//         this.createdAt,
//         this.updatedAt,
//         this.isPurchased});
//
//   Category.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     buttonTitle = json['button_title'];
//     price = json['price'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     isPurchased = json['is_purchased'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['button_title'] = this.buttonTitle;
//     data['price'] = this.price;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['is_purchased'] = this.isPurchased;
//     return data;
//   }
// }
//
// class Image {
//   int? id;
//   String? typeId;
//   String? fileName;
//   String? type;
//   String? createdAt;
//   String? updatedAt;
//   String? imageUrl;
//
//   Image(
//       {this.id,
//         this.typeId,
//         this.fileName,
//         this.type,
//         this.createdAt,
//         this.updatedAt,
//         this.imageUrl});
//
//   Image.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     typeId = json['type_id'];
//     fileName = json['file_name'];
//     type = json['type'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     imageUrl = json['image_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['type_id'] = this.typeId;
//     data['file_name'] = this.fileName;
//     data['type'] = this.type;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['image_url'] = this.imageUrl;
//     return data;
//   }
// }
//
// class Audio {
//   int? id;
//   String? title;
//   int? categoryId;
//   String? duration;
//   String? isFeatured;
//   String? uniqueId;
//   int? canViewFreeUser;
//   int? audioType;
//   String? createdAt;
//   String? updatedAt;
//   String? thumbnailImageUrl;
//   String? audioUrl;
//   Category? category;
//   Image? image;
//   Image? audio;
//
//   Audio(
//       {this.id,
//         this.title,
//         this.categoryId,
//         this.duration,
//         this.isFeatured,
//         this.uniqueId,
//         this.canViewFreeUser,
//         this.audioType,
//         this.createdAt,
//         this.updatedAt,
//         this.thumbnailImageUrl,
//         this.audioUrl,
//         this.category,
//         this.image,
//         this.audio});
//
//   Audio.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     categoryId = json['category_id'];
//     duration = json['duration'];
//     isFeatured = json['is_featured'];
//     uniqueId = json['unique_id'];
//     canViewFreeUser = json['can_view_free_user'];
//     audioType = json['audio_type'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     thumbnailImageUrl = json['thumbnail_image_url'];
//     audioUrl = json['audio_url'];
//     category = json['category'] != null
//         ? new Category.fromJson(json['category'])
//         : null;
//     image = json['image'] != null ? new Image.fromJson(json['image']) : null;
//     audio = json['audio'] != null ? new Image.fromJson(json['audio']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['category_id'] = this.categoryId;
//     data['duration'] = this.duration;
//     data['is_featured'] = this.isFeatured;
//     data['unique_id'] = this.uniqueId;
//     data['can_view_free_user'] = this.canViewFreeUser;
//     data['audio_type'] = this.audioType;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['thumbnail_image_url'] = this.thumbnailImageUrl;
//     data['audio_url'] = this.audioUrl;
//     if (this.category != null) {
//       data['category'] = this.category!.toJson();
//     }
//     if (this.image != null) {
//       data['image'] = this.image!.toJson();
//     }
//     if (this.audio != null) {
//       data['audio'] = this.audio!.toJson();
//     }
//     return data;
//   }
// }



class PlaylistDetailResponse {
  bool? status;
  String? message;
  Data? data;

  PlaylistDetailResponse({this.status, this.message, this.data});

  PlaylistDetailResponse.fromJson(Map<String, dynamic> json) {
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
  List<PlaylistVideoList>? playlistVideoList;
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;

  Data(
      {this.playlistVideoList,
        this.currentPage,
        this.perPage,
        this.total,
        this.lastPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['playlist_video_list'] != null) {
      playlistVideoList = <PlaylistVideoList>[];
      json['playlist_video_list'].forEach((v) {
        playlistVideoList!.add(PlaylistVideoList.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (playlistVideoList != null) {
      data['playlist_video_list'] =
          playlistVideoList!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['last_page'] = lastPage;
    return data;
  }
}

class PlaylistVideoList {
  int? id;
  int? userId;
  int? playlistId;
  int? videoId;
  int? audioId;
  String? videoTitle;
  String? createdAt;
  String? updatedAt;
  String? categoryTitle;
  // Video? video;
  VideoResponse? video;

  PlaylistVideoList(
      {this.id,
        this.userId,
        this.playlistId,
        this.videoId,
        this.audioId,
        this.videoTitle,
        this.createdAt,
        this.updatedAt,
        this.categoryTitle,
        this.video});

  PlaylistVideoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    playlistId = json['playlist_id'];
    videoId = json['video_id'];
    audioId = json['audio_id'];
    videoTitle = json['video_title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryTitle = json['category_title'];
    if(json['video'] != null){
      video = json['video'] != null ? VideoResponse.fromJson(json['video'], false) : null;
    }else if(json['audio'] != null){
      video = json['audio'] != null ? VideoResponse.fromJson(json['audio'], true) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['playlist_id'] = playlistId;
    data['video_id'] = videoId;
    data['audio_id'] = audioId;
    data['video_title'] = videoTitle;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['category_title'] = categoryTitle;
    if (video != null) {
      data['video'] = video!.toJson();
    }
    return data;
  }
}

class Video {
  int? id;
  String? title;
  int? categoryId;
  String? uniqueId;
  int? canViewFreeUser;
  String? thumbnailImageUrl;
  String? videoUrl;
  String? duration;

  Video(
      {this.id,
        this.title,
        this.categoryId,
        this.uniqueId,
        this.canViewFreeUser,
        this.thumbnailImageUrl,
        this.duration,
        this.videoUrl});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    categoryId = json['category_id'];
    uniqueId = json['unique_id'];
    canViewFreeUser = json['can_view_free_user'];
    thumbnailImageUrl = json['thumbnail_image_url'];
    videoUrl = json['video_url'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['category_id'] = categoryId;
    data['unique_id'] = uniqueId;
    data['can_view_free_user'] = canViewFreeUser;
    data['thumbnail_image_url'] = thumbnailImageUrl;
    data['video_url'] = videoUrl;
    data['duration'] = duration;
    return data;
  }
}
