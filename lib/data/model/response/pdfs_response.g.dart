// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdfs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PdfsResponse _$PdfsResponseFromJson(Map<String, dynamic> json) => PdfsResponse(
      currentPage: json['current_page'] as int,
      limit: json['per_page'] as int,
      total: json['total'] as int,
      lastPage: json['last_page'] as int?,
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => PdfResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

PdfResponse _$PdfResponseFromJson(Map<String, dynamic> json) => PdfResponse(
      category: CategoryListResponse.fromJson(json['category']),
      id: json['id'] as int?,
      title: json['title'] as String?,
      categoryId: json['category_id'] as int?,
      categoryTitle: json['category_title'] as String?,
      uniqueId: json['unique_id'] as String?,
      pdfType: ResourceType.fromJson(json['pdf_type'] as int?),
      pdfUrlSrc: json['pdf_url'] as String?,
      pdf: json['pdf'] == null
          ? null
          : MediaResponse.fromJson(json['pdf'] as Map<String, dynamic>),
    );
