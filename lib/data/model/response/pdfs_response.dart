import 'package:json_annotation/json_annotation.dart';

import '../body/resource_type.dart';
import 'category_list_reponse.dart';
import 'video_response_media.dart';

part 'pdfs_response.g.dart';

// {
//     "status": true,
//     "message": "Pdf list",
//     "data": {
//         "pdf_list": [
//             {
//                 "id": 1,
//                 "title": "Dummy PDF Free",
//                 "category_id": 2,
//                 "unique_id": "Ii6pMTV",
//                 "can_view_free_user": 0,
//                 "pdf_type": 0,
//                 "category_title": "Ketogenic",
//                 "pdf_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/pdf/Pdf_1_93830.pdf",
//                 "pdf": {
//                     "id": 18,
//                     "type_id": "1",
//                     "file_name": "Pdf_1_93830.pdf",
//                     "type": "pdf",
//                     "image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/pdf/Pdf_1_93830.pdf"
//                 }
//             }
//         ],
//         "current_page": 1,
//         "per_page": 10,
//         "total": 1,
//         "last_page": 1
//     }
// }

@JsonSerializable(createToJson: false, explicitToJson: false)
class PdfsResponse {
  @JsonKey(name: 'current_page')
  int currentPage;
  @JsonKey(name: 'per_page')
  int limit;
  @JsonKey(name: 'total')
  int total;
  @JsonKey(name: 'last_page')
  int? lastPage;

  @JsonKey(name: 'list')
  final List<PdfResponse>? list;

  PdfsResponse({
    required this.currentPage,
    required this.limit,
    required this.total,
    required this.lastPage,
    required this.list,
  });

  factory PdfsResponse.fromJson(Map<String, dynamic> json) => _$PdfsResponseFromJson(json);
}

@JsonSerializable(createToJson: false, explicitToJson: false)
class PdfResponse {
  final int? id;
  final String? title;
  @JsonKey(name: 'category_id')
  final int? categoryId;
  @JsonKey(name: 'category_title')
  final String? categoryTitle;

  @JsonKey(name: 'unique_id')
  final String? uniqueId;

  /// Don't use this variable for [feature_list]
  /// no need to use this variable beacause [feature_list] always return [free] vedio list
  @JsonKey(name: 'pdf_type', fromJson: ResourceType.fromJson)
  final ResourceType? pdfType;
  // @JsonKey(name: 'is_bookmark')
  // bool? bookmarked;

  /// insted of using Below Field [pdfUrlSrc] use [pdfUrl]
  @JsonKey(name: 'pdf_url', includeFromJson: true)
  final String? pdfUrlSrc;

  /// insted of using Below Field [pdf] use [pdfUrl]
  @JsonKey(name: 'pdf', includeFromJson: true)
  final MediaResponse? pdf;

  @JsonKey(name: 'category', fromJson: CategoryListResponse.fromJson)
  final CategoryListResponse? category;

  /// No Use of below variable
  // int can_view_free_user;

  const PdfResponse({
    required this.category,
    required this.id,
    required this.title,
    required this.categoryId,
    required this.categoryTitle,
    required this.uniqueId,
    required this.pdfType,
    required this.pdfUrlSrc,
    required this.pdf,
  });

  String? get pdfUrl => pdfUrlSrc ?? pdf?.url;

  factory PdfResponse.fromJson(Map<String, dynamic> json) => _$PdfResponseFromJson(json);
}
