import 'package:json_annotation/json_annotation.dart';

part 'category_and_video_name_model.g.dart';

@JsonSerializable(explicitToJson: false, createToJson: false)
class CategoryNames {
  @JsonKey(name: 'category_list')
  final List<ItemName> list;

  const CategoryNames({required this.list});

  factory CategoryNames.fromJson(Map<String, dynamic> json) => _$CategoryNamesFromJson(json);
}

@JsonSerializable(explicitToJson: false, createToJson: false)
class VideoNames {
  @JsonKey(name: 'video_list')
  final List<ItemName> list;

  const VideoNames({required this.list});

  factory VideoNames.fromJson(Map<String, dynamic> json) => _$VideoNamesFromJson(json);
}

@JsonSerializable(explicitToJson: false, createToJson: false)
class ItemName {
  final int id;
  final String title;

  ItemName({required this.id, required this.title});
  factory ItemName.fromJson(Map<String, dynamic> json) => _$ItemNameFromJson(json);
}
