/// {
///   "id": 3,
///   "user_id": 2,
///   "video_id": 2,
///   "video_title": "video2",
///   "created_at": "2023-08-11T07:43:59.000000Z",
///   "updated_at": "2023-08-11T07:43:59.000000Z",
///   "video": {
///     "id": 2,
///     "title": "video2",
///     "thumbnail_image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_thumbnail_2_89504.jpg",
///     "video_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_2_49607.mp4"
///   }
/// }


class BookmarkListResponse {
  int? id;
  int? userId;
  int? videoId;
  String? videoTitle;
  String? createdAt;
  String? updatedAt;
  BookmarkVideoResponse? bookmarkVideoResponse;

  BookmarkListResponse({this.id, this.userId, this.videoId, this.videoTitle, this.createdAt, this.updatedAt, this.bookmarkVideoResponse});

  BookmarkListResponse.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    videoId = json['video_id'];
    videoTitle = json['video_title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['video'] != null) bookmarkVideoResponse = json['video'];
  }
}

class BookmarkVideoResponse {
  int? id;
  String? title;
  String? thumbnailImageUrl;
  String? videoUrl;

  BookmarkVideoResponse({this.id, this.title, this.thumbnailImageUrl, this.videoUrl});

  BookmarkVideoResponse.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    thumbnailImageUrl = json['thumbnail_image_url'];
    videoUrl = json['video_url'];
  }
}