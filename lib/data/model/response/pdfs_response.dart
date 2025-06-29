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

// @JsonSerializable(createToJson: false, explicitToJson: false)
// class PdfsResponse {
//   @JsonKey(name: 'current_page')
//   int currentPage;
//   @JsonKey(name: 'per_page')
//   int limit;
//   @JsonKey(name: 'total')
//   int total;
//   @JsonKey(name: 'last_page')
//   int? lastPage;
//
//   @JsonKey(name: 'list')
//   final List<PdfResponse>? list;
//
//   PdfsResponse({
//     required this.currentPage,
//     required this.limit,
//     required this.total,
//     required this.lastPage,
//     required this.list,
//   });
//
//   factory PdfsResponse.fromJson(Map<String, dynamic> json) => _$PdfsResponseFromJson(json);
// }
//
// @JsonSerializable(createToJson: false, explicitToJson: false)
// class PdfResponse {
//   final int? id;
//   final String? title;
//   @JsonKey(name: 'category_id')
//   final int? categoryId;
//   @JsonKey(name: 'category_title')
//   final String? categoryTitle;
//
//   @JsonKey(name: 'unique_id')
//   final String? uniqueId;
//
//   /// Don't use this variable for [feature_list]
//   /// no need to use this variable beacause [feature_list] always return [free] vedio list
//   @JsonKey(name: 'pdf_type', fromJson: ResourceType.fromJson)
//   final ResourceType? pdfType;
//   // @JsonKey(name: 'is_bookmark')
//   // bool? bookmarked;
//
//   /// insted of using Below Field [pdfUrlSrc] use [pdfUrl]
//   @JsonKey(name: 'pdf_url', includeFromJson: true)
//   final String? pdfUrlSrc;
//
//   /// insted of using Below Field [pdf] use [pdfUrl]
//   @JsonKey(name: 'pdf', includeFromJson: true)
//   final MediaResponse? pdf;
//
//   @JsonKey(name: 'category', fromJson: CategoryListResponse.fromJson)
//   final CategoryListResponse? category;
//
//   /// No Use of below variable
//   // int can_view_free_user;
//
//   PdfResponse({
//     required this.category,
//     required this.id,
//     required this.title,
//     required this.categoryId,
//     required this.categoryTitle,
//     required this.uniqueId,
//     required this.pdfType,
//     required this.pdfUrlSrc,
//     required this.pdf,
//   });
//
//   String? get pdfUrl => pdfUrlSrc ?? pdf?.url;
//
//   factory PdfResponse.fromJson(Map<String, dynamic> json) => _$PdfResponseFromJson(json);
// }

class PdfsResponse {
  final int currentPage;
  final int limit;
  final int total;
  final int? lastPage;
  final List<PdfResponse>? list;

  PdfsResponse({
    required this.currentPage,
    required this.limit,
    required this.total,
    this.lastPage,
    this.list,
  });

  factory PdfsResponse.fromJson(Map<String, dynamic> json) {
    return PdfsResponse(
      currentPage: json['current_page'] ?? 0,
      limit: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      lastPage: json['last_page'],
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => PdfResponse.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': limit,
      'total': total,
      'last_page': lastPage,
      'list': list?.map((e) => e.toJson()).toList(),
    };
  }
}

class PdfResponse {
  final int? id;
  final String? title;
  final int? categoryId;
  final String? categoryTitle;
  final String? uniqueId;
  final ResourceType? pdfType;
  final String? pdfUrlSrc;
  final MediaResponse? pdf;
  final CategoryListResponse? category;

  PdfResponse({
    this.id,
    this.title,
    this.categoryId,
    this.categoryTitle,
    this.uniqueId,
    this.pdfType,
    this.pdfUrlSrc,
    this.pdf,
    this.category,
  });

  String? get pdfUrl => pdfUrlSrc ?? pdf?.url;

  factory PdfResponse.fromJson(Map<String, dynamic> json) {
    return PdfResponse(
      id: json['id'],
      title: json['title'],
      categoryId: json['category_id'],
      categoryTitle: json['category_title'],
      uniqueId: json['unique_id'],
      pdfType: ResourceType.fromJson(json['pdf_type']),
      pdfUrlSrc: json['pdf_url'],
      pdf: json['pdf'] != null ? MediaResponse.fromJson(json['pdf']) : null,
      category: json['category'] != null
          ? CategoryListResponse.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category_id': categoryId,
      'category_title': categoryTitle,
      'unique_id': uniqueId,
      'pdf_type': pdfType,
      'pdf_url': pdfUrlSrc,
      'pdf': pdf?.toJson(),
      'category': category?.toJson(),
    };
  }
}

