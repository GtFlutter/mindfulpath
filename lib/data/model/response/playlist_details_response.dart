class Playlist_Detail_Response {
  bool? status;
  String? message;
  Data? data;

  Playlist_Detail_Response({this.status, this.message, this.data});

  Playlist_Detail_Response.fromJson(Map<String, dynamic> json) {
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
        playlistVideoList!.add(new PlaylistVideoList.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.playlistVideoList != null) {
      data['playlist_video_list'] =
          this.playlistVideoList!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
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
  Video? video;

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
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['playlist_id'] = this.playlistId;
    data['video_id'] = this.videoId;
    data['video_title'] = this.videoTitle;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_title'] = this.categoryTitle;
    if (this.video != null) {
      data['video'] = this.video!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['category_id'] = this.categoryId;
    data['unique_id'] = this.uniqueId;
    data['can_view_free_user'] = this.canViewFreeUser;
    data['thumbnail_image_url'] = this.thumbnailImageUrl;
    data['video_url'] = this.videoUrl;
    data['duration'] = this.duration;
    return data;
  }
}
