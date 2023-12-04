// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_videos_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedVideosResponse _$FeaturedVideosResponseFromJson(
        Map<String, dynamic> json) =>
    FeaturedVideosResponse(
      currentPage: json['current_page'] as int,
      limit: json['per_page'] as int,
      total: json['total'] as int,
      lastPage: json['last_page'] as int?,
      list: (json['featured_video_list'] as List<dynamic>?)
          ?.map(FeaturedVideoResponse.fromJson)
          .toList(),
    );

FeaturedVideoResponse _$FeaturedVideoResponseFromJson(
        Map<String, dynamic> json) =>
    FeaturedVideoResponse(
      id: json['id'] as int?,
      title: json['title'] as String?,
      duration: json['duration'] as String?,
      uniqueId: json['unique_id'] as String?,
      bookmarked: json['is_bookmark'] as bool?,
      thumbnailImageUrlSrc: json['thumbnail_image_url'] as String?,
      image: json['image'] == null
          ? null
          : MediaResponse.fromJson(json['image'] as Map<String, dynamic>),
      videoUrlSrc: json['video_url'] as String?,
      video: json['video'] == null
          ? null
          : MediaResponse.fromJson(json['video'] as Map<String, dynamic>),
      category: CategoryListResponse.fromJson(json['category']),
    );
