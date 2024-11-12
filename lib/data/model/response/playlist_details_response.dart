import 'package:meditation_app/data/model/response/videos_response.dart';

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
