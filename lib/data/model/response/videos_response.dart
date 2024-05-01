import 'package:json_annotation/json_annotation.dart';

import '../body/resource_type.dart';
import 'category_list_reponse.dart';
import 'video_response_media.dart';

part 'videos_response.g.dart';

// {
//   "status": true,
//   "message": "Video list",
//   "data": {
//     "video_list": [
//       {
//         "id": 1,
//         "title": "video1",
//         "category_id": "1",
//         "duration": "00:00:13.000",
//         "unique_id": "Fk3ykty",
//         // no use of it
//         "can_view_free_user": 0,
//         "video_type": 0,
//         "category_title": "Mindful",
//         "is_bookmark": false,
//         "thumbnail_image_url":
//             "https:\/\/gurutechnolabs.co.in\/website\/laravel\/meditation\/public\/video\/Video_thumbnail_1_92394.jpg",
//         "video_url": "https:\/\/gurutechnolabs.co.in\/website\/laravel\/meditation\/public\/video\/Video_1_57650.mp4",
//         "image": {
//           "id": 3,
//           "type_id": "1",
//           "file_name": "Video_thumbnail_1_92394.jpg",
//           "type": "video_thumbnail_image",
//           "image_url":
//               "https:\/\/gurutechnolabs.co.in\/website\/laravel\/meditation\/public\/video\/Video_thumbnail_1_92394.jpg"
//         },
//         "video": {
//           "id": 4,
//           "type_id": "1",
//           "file_name": "Video_1_57650.mp4",
//           "type": "video",
//           "image_url": "https:\/\/gurutechnolabs.co.in\/website\/laravel\/meditation\/public\/video\/Video_1_57650.mp4"
//         }
//       }
//     ],
//     "current_page": 1,
//     "per_page": 10,
//     "total": 1,
//     "last_page": 1
//   }
// }

@JsonSerializable(createToJson: false, explicitToJson: false)
class VideosResponse {
  @JsonKey(name: 'current_page')
  int currentPage;
  @JsonKey(name: 'per_page')
  int limit;
  @JsonKey(name: 'total')
  int total;
  @JsonKey(name: 'last_page')
  int? lastPage;

  @JsonKey(name: 'list')
  final List<VideoResponse>? list;

  @JsonKey(name: 'cat_list')
  final CategoryListResponse? category;



  VideosResponse({
    required this.currentPage,
    required this.limit,
    required this.total,
    required this.lastPage,
    required this.list,
    this.category
  });

  factory VideosResponse.fromJson(Map<String, dynamic> json) => _$VideosResponseFromJson(json);
}

@JsonSerializable()
class VideoResponse {
  final int? id;
  final String? title;
  @JsonKey(name: 'category_id')
  final int? categoryId;
  @JsonKey(name: 'category_title')
  final String? categoryTitle;
  final String? duration;
  @JsonKey(name: 'unique_id')
  final String? uniqueId;

  /// Don't use this variable for [feature_list]
  /// no need to use this variable beacause [feature_list] always return [free] vedio list
  @JsonKey(name: 'video_type', fromJson: ResourceType.fromJson)
  final ResourceType? videoType;
  @JsonKey(name: 'is_bookmark')
  bool? bookmarked;

  /// insted of using Below Field [thumbnailImageUrlSrc] use [imgUrl] getter
  @JsonKey(name: 'thumbnail_image_url')
  final String? thumbnailImageUrlSrc;

  /// insted of using Below Field [image] use [imgUrl] getter
  @JsonKey(name: 'image', includeFromJson: true)
  final MediaResponse? image;

  /// insted of using Below Field [videoUrlSrc] use [videoUrl]
  @JsonKey(name: 'video_url', includeFromJson: true)
  final String? videoUrlSrc;

  /// insted of using Below Field [video] use [videoUrl]
  @JsonKey(name: 'video', includeFromJson: true)
  final MediaResponse? video;

  @JsonKey(name: 'category', fromJson: CategoryListResponse.fromJson, toJson: categoryToJson)
  final CategoryListResponse? category;

  /// No Use of below variable
  // int can_view_free_user;

  VideoResponse({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.categoryTitle,
    required this.duration,
    required this.uniqueId,
    required this.videoType,
    required this.bookmarked,
    required this.thumbnailImageUrlSrc,
    required this.videoUrlSrc,
    required this.image,
    required this.video,
    required this.category,
  });

  String? get imgUrl => thumbnailImageUrlSrc ?? image?.url;
  String? get videoUrl => videoUrlSrc ?? video?.url;

  factory VideoResponse.fromJson(Map<String, dynamic> json) => _$VideoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VideoResponseToJson(this);

  static categoryToJson(CategoryListResponse? category) => category?.toJson();
}
