import 'package:json_annotation/json_annotation.dart';
part 'video_response_media.g.dart';

@JsonSerializable(createToJson: false, explicitToJson: false)
class MediaResponse {
  final int? id;
  @JsonKey(name: 'type_id')
  final String? typeId;
  @JsonKey(name: 'file_name')
  final String? fileName;
  final String? type;
  @JsonKey(name: 'image_url')
  final String? url;

  const MediaResponse({
    required this.id,
    required this.typeId,
    required this.fileName,
    required this.type,
    required this.url,
  });
  factory MediaResponse.fromJson(Map<String, dynamic> json) => _$MediaResponseFromJson(json);
}
