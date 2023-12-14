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
      lastPage: json['last_page'] as int?,
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => VideoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

VideoResponse _$VideoResponseFromJson(Map<String, dynamic> json) =>
    VideoResponse(
      id: json['id'] as int?,
      title: json['title'] as String?,
      categoryId: json['category_id'] as int?,
      categoryTitle: json['category_title'] as String?,
      duration: json['duration'] as String?,
      uniqueId: json['unique_id'] as String?,
      videoType: ResourceType.fromJson(json['video_type'] as int?),
      bookmarked: json['is_bookmark'] as bool?,
      thumbnailImageUrlSrc: json['thumbnail_image_url'] as String?,
      videoUrlSrc: json['video_url'] as String?,
      image: json['image'] == null
          ? null
          : MediaResponse.fromJson(json['image'] as Map<String, dynamic>),
      video: json['video'] == null
          ? null
          : MediaResponse.fromJson(json['video'] as Map<String, dynamic>),
      category: CategoryListResponse.fromJson(json['category']),
    );

Map<String, dynamic> _$VideoResponseToJson(VideoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category_id': instance.categoryId,
      'category_title': instance.categoryTitle,
      'duration': instance.duration,
      'unique_id': instance.uniqueId,
      'video_type': _$ResourceTypeEnumMap[instance.videoType],
      'is_bookmark': instance.bookmarked,
      'thumbnail_image_url': instance.thumbnailImageUrlSrc,
      'image': instance.image,
      'video_url': instance.videoUrlSrc,
      'video': instance.video,
      'category': VideoResponse.categoryToJson(instance.category),
    };

const _$ResourceTypeEnumMap = {
  ResourceType.free: 'free',
  ResourceType.paid: 'paid',
};
