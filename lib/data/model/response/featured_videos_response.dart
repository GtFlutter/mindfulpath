import 'package:json_annotation/json_annotation.dart';

import 'category_list_reponse.dart';
import 'video_response_media.dart';

part 'featured_videos_response.g.dart';
// var a = {
//   "id": 1,
//   "title": "video1",
//   "duration": "00:00:13.000",
//   "unique_id": "Fk3ykty",
//   "can_view_free_user": 0,
//   "is_bookmark": false,
//   "thumbnail_image_url":
//       "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_thumbnail_1_92394.jpg",
//   "video_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_1_57650.mp4",
//   "category": {
//     "id": 1,
//     "title": "Mindful",
//     "button_title": "Meditation",
//     "price": "",
//     "created_at": "2023-08-09T11:48:04.000000Z",
//     "updated_at": "2023-08-16T05:49:52.000000Z",
//     "image": {
//       "id": 12,
//       "type_id": "1",
//       "file_name": "Category_1_97664.jpeg",
//       "type": "category_image",
//       "created_at": "2023-08-16T06:02:48.000000Z",
//       "updated_at": "2023-08-16T06:02:48.000000Z",
//       "image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/category_image/Category_1_97664.jpeg"
//     }
//   },
//   "image": {
//     "id": 3,
//     "type_id": "1",
//     "file_name": "Video_thumbnail_1_92394.jpg",
//     "type": "video_thumbnail_image",
//     "image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_thumbnail_1_92394.jpg"
//   },
//   "video": {
//     "id": 4,
//     "type_id": "1",
//     "file_name": "Video_1_57650.mp4",
//     "type": "video",
//     "image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_1_57650.mp4"
//   }
// };

@JsonSerializable(createToJson: false, explicitToJson: false)
class FeaturedVideosResponse {
  @JsonKey(name: 'current_page')
  int currentPage;
  @JsonKey(name: 'per_page')
  int limit;
  @JsonKey(name: 'total')
  int total;
  @JsonKey(name: 'last_page')
  int? lastPage;

  @JsonKey(name: 'featured_video_list')
  final List<FeaturedVideoResponse>? list;

  FeaturedVideosResponse({
    required this.currentPage,
    required this.limit,
    required this.total,
    required this.lastPage,
    required this.list,
  });

  factory FeaturedVideosResponse.fromJson(Map<String, dynamic> json) => _$FeaturedVideosResponseFromJson(json);
}

@JsonSerializable(createToJson: false, explicitToJson: false)
class FeaturedVideoResponse {
  final int? id;
  final String? title;
  final String? duration;

  @JsonKey(name: 'unique_id')
  final String? uniqueId;

  // // Don't use this variable for [feature_list]
  // // no need to use this variable beacause [feature_list] always return [free] vedio list
  // // No Use of below variable
  // int can_view_free_user;

  @JsonKey(name: 'is_bookmark')
  final bool? bookmarked;

  /// insted of using Below Field [thumbnailImageUrlSrc] use [imgUrl] getter
  @JsonKey(name: 'thumbnail_image_url')
  final String? thumbnailImageUrlSrc;

  /// insted of using Below Field [image] use [imgUrl] getter
  @JsonKey(name: 'image', includeFromJson: true)
  final VideoResponseMedia? image;

  /// insted of using Below Field [videoUrlSrc] use [videoUrl]
  @JsonKey(name: 'video_url', includeFromJson: true)
  final String? videoUrlSrc;

  /// insted of using Below Field [video] use [videoUrl]
  @JsonKey(name: 'video', includeFromJson: true)
  final VideoResponseMedia? video;

  @JsonKey(name: 'category', fromJson: CategoryListResponse.fromJson)
  final CategoryListResponse? category;

  const FeaturedVideoResponse({
    required this.id,
    required this.title,
    required this.duration,
    required this.uniqueId,
    required this.bookmarked,
    required this.thumbnailImageUrlSrc,
    required this.image,
    required this.videoUrlSrc,
    required this.video,
    required this.category,
  });

  String? get imgUrl => thumbnailImageUrlSrc ?? image?.url;
  String? get videoUrl => videoUrlSrc ?? video?.url;

  factory FeaturedVideoResponse.fromJson(dynamic json) => _$FeaturedVideoResponseFromJson(json);
}
