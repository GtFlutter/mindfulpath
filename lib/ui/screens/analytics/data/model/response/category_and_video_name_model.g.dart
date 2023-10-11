// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_and_video_name_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryNames _$CategoryNamesFromJson(Map<String, dynamic> json) =>
    CategoryNames(
      list: (json['category_list'] as List<dynamic>)
          .map((e) => ItemName.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

VideoNames _$VideoNamesFromJson(Map<String, dynamic> json) => VideoNames(
      list: (json['video_list'] as List<dynamic>)
          .map((e) => ItemName.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

ItemName _$ItemNameFromJson(Map<String, dynamic> json) => ItemName(
      id: json['id'] as int,
      title: json['title'] as String,
    );
