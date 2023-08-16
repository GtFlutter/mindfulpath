/// {
///   "id": 2,
///   "title": "video2",
///   "category_id": "2",
///   "duration": "00:00:05.000",
///   "thumbnail_image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_thumbnail_2_89504.jpg",
///   "video_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_2_49607.mp4",
///   "image": {
///     "id": 5,
///     "type_id": "2",
///     "file_name": "Video_thumbnail_2_89504.jpg",
///     "type": "video_thumbnail_image",
///     "image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_thumbnail_2_89504.jpg"
///   },
///   "video": {
///     "id": 6,
///     "type_id": "2",
///     "file_name": "Video_2_49607.mp4",
///     "type": "video",
///     "image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_2_49607.mp4"
///   }
/// },


class VideoListResponse {
  int? id;
  String? title;
  String? categoryId;
  String? duration;
  String? thumbnailImage;
  String? videoUrl;
  bool? bookmark;
  VideoImageResponse? imageResponse;
  VideoImageResponse? videResponse;

  VideoListResponse({this.id, this.title, this.categoryId, this.duration, this.thumbnailImage, this.videoUrl, this.imageResponse, this.videResponse,this.bookmark=false});

  VideoListResponse.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    categoryId = json['category_id'];
    duration = json['duration'];
    thumbnailImage = json['thumbnail_image_url'];
    videoUrl = json['video_url'];
    bookmark=false;
    if (json['image'] != null) imageResponse = VideoImageResponse.fromJson(json['image']);
    if (json['video'] != null) videResponse = VideoImageResponse.fromJson(json['video']);
  }

  static List<VideoListResponse> listFromJson(dynamic jsonList) {
    List<VideoListResponse> list = [];
    for (var json in jsonList) {
      list.add(VideoListResponse.fromJson(json));
    }
    return list;
  }
}

class VideoImageResponse {
  int? id;
  String? typeId;
  String? fileName;
  String? type;
  String? imageUrl;

  VideoImageResponse({this.id, this.typeId, this.fileName, this.type, this.imageUrl});

  VideoImageResponse.fromJson(dynamic json) {
    id = json['id'];
    typeId = json['type_id'];
    fileName = json['file_name'];
    type = json['type'];
    imageUrl = json['image_url'];
  }
}