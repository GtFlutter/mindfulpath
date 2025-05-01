import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/data/model/response/pdfs_response.dart';
import 'package:meditation_app/data/model/response/video_response_media.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';

import 'body/resource_type.dart';

class AllItem {
  final int? id;
  final String? title;
  final int? categoryId;
  final bool isAudio;
  final String? categoryTitle;
  final String? duration;
  final String? uniqueId;

  // PDF-Specific Properties (nullable)
  final ResourceType? pdfType;
  final String? pdfUrlSrc;
  final MediaResponse? pdf;
  final List<PdfResponse>? pdfList;

  // Video-Specific Properties (nullable)
  final ResourceType? videoType;
  final List<VideoResponse>? list;
  final bool? bookmarked;
  final String? thumbnailImageUrlSrc;
  final String? videoUrlSrc;
  final MediaResponse? image;
  final MediaResponse? video;

  // Common Category
  final CategoryListResponse? category;

  AllItem({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.categoryTitle,
    required this.isAudio,
    this.duration,
    this.uniqueId,
    this.pdfType,
    this.pdfUrlSrc,
    this.pdf,
    this.pdfList,
    this.list,
    this.videoType,
    this.bookmarked,
    this.thumbnailImageUrlSrc,
    this.videoUrlSrc,
    this.image,
    this.video,
    required this.category,
  });

  String? get imgUrl => thumbnailImageUrlSrc ?? image?.url;
  String? get videoUrl => videoUrlSrc ?? video?.url;
  String? get pdfUrl => pdfUrlSrc ?? pdf?.url;

  // Factory constructor to create an AllItem from a JSON map
  factory AllItem.fromJson(Map<String, dynamic> json, bool isFromAudio) {
    return AllItem(
      id: json['id'] as int?,
      title: json['title'] as String?,
      categoryId: json['categoryId'] as int?,
      categoryTitle: json['categoryTitle'] as String?,
      isAudio: isFromAudio,
      duration: json['duration'] as String?,
      uniqueId: json['uniqueId'] as String?,
      pdfType: ResourceType.fromJson(json['pdf_type'] as int?),
      pdfUrlSrc: json['pdfUrlSrc'] as String?,
      pdf: json['pdf'] != null ? MediaResponse.fromJson(json['pdf'] as Map<String, dynamic>) : null,
      pdfList: (json['list'] as List<dynamic>?)?.map((e) => PdfResponse.fromJson(e as Map<String, dynamic>)).toList(),
      list: (json['list'] as List<dynamic>?)?.map((e) => VideoResponse.fromJson(e as Map<String, dynamic>, isFromAudio)).toList(),
      videoType: isFromAudio ? ResourceType.fromJson(json['audio_type'] as int?) : ResourceType.fromJson(json['video_type'] as int?),
      bookmarked: json['bookmarked'] as bool?,
      thumbnailImageUrlSrc: json['thumbnailImageUrlSrc'] as String?,
      videoUrlSrc: isFromAudio ? json['audio_url'] as String? : json['video_url'] as String?,
      image: json['image'] != null ? MediaResponse.fromJson(json['image'] as Map<String, dynamic>) : null,
      video: json['video'] != null ? MediaResponse.fromJson(json['video'] as Map<String, dynamic>) : null,
      category: json['category'] != null ? CategoryListResponse.fromJson(json['category'] as Map<String, dynamic>) : null,
    );
  }

  // Factory constructor to create an AllItem from a VideoResponse
  factory AllItem.fromVideo(VideoResponse video) {
    return AllItem(
      id: video.id,
      title: video.title,
      categoryId: video.categoryId,
      categoryTitle: video.categoryTitle,
      isAudio: false,
      duration: video.duration,
      uniqueId: video.uniqueId,
      bookmarked: video.bookmarked,
      image: video.image,
      video: video.video,
      pdf: null,
      category: video.category,
    );
  }

  // Factory constructor to create an AllItem from a PdfResponse
  factory AllItem.fromPdf(PdfResponse pdf) {
    return AllItem(
      id: pdf.id,
      title: pdf.title,
      categoryId: pdf.categoryId,
      categoryTitle: pdf.categoryTitle,
      isAudio: false,
      duration: null,
      uniqueId: pdf.uniqueId,
      bookmarked: false, // PDF has no bookmark
      image: null,
      video: null,
      pdf: pdf.pdf,
      category: pdf.category,
    );
  }

  // Method to convert an AllItem to a JSON map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'categoryId': categoryId,
      'categoryTitle': categoryTitle,
      'duration': duration,
      'uniqueId': uniqueId,
      'pdfType': pdfType,
      'pdfUrlSrc': pdfUrlSrc,
      'pdf': pdf?.toJson(),
      'videoType': videoType,
      'bookmarked': bookmarked,
      'thumbnailImageUrlSrc': thumbnailImageUrlSrc,
      'videoUrlSrc': videoUrlSrc,
      'image': image?.toJson(),
      'video': video?.toJson(),
      'category': category?.toJson(),
    };
  }
}
