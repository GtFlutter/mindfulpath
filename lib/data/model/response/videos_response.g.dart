// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videos_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideosResponse _$VideosResponseFromJson(Map<String, dynamic> json) =>
    VideosResponse(
      currentPage: json['current_page'] as int,
      limit: json['per_page'] as int,
      total: json['total'] as int,
      list: (json['video_list'] as List<dynamic>?)
          ?.map((e) => VideoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

VideoResponse _$VideoResponseFromJson(Map<String, dynamic> json) =>
    VideoResponse(
      id: json['id'] as int?,
      title: json['title'] as String?,
      categoryId: json['category_id'] as String?,
      categoryTitle: json['category_title'] as String?,
      duration: json['duration'] as String?,
      uniqueId: json['unique_id'] as String?,
      videoType: VideoResponse.videoTypeFromJson(json['video_type'] as int?),
      bookmarked: json['is_bookmark'] as bool?,
      thumbnailImageUrlSrc: json['thumbnail_image_url'] as String?,
      videoUrlSrc: json['video_url'] as String?,
      image: json['image'] == null
          ? null
          : VideoResponseMedia.fromJson(json['image'] as Map<String, dynamic>),
      video: json['video'] == null
          ? null
          : VideoResponseMedia.fromJson(json['video'] as Map<String, dynamic>),
    );
