// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_response_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaResponse _$MediaResponseFromJson(Map<String, dynamic> json) =>
    MediaResponse(
      id: json['id'] as int?,
      typeId: json['type_id'] as String?,
      fileName: json['file_name'] as String?,
      type: json['type'] as String?,
      url: json['image_url'] as String?,
    );

Map<String, dynamic> _$MediaResponseToJson(MediaResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type_id': instance.typeId,
      'file_name': instance.fileName,
      'type': instance.type,
      'image_url': instance.url,
    };
