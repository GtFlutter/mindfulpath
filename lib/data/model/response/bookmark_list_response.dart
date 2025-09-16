/// {
///   "id": 3,
///   "user_id": 2,
///   "video_id": 2,
///   "video_title": "video2",
///   "created_at": "2023-08-11T07:43:59.000000Z",
///   "updated_at": "2023-08-11T07:43:59.000000Z",
///   "video": {
///     "id": 2,
///     "title": "video2",
///     "thumbnail_image_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_thumbnail_2_89504.jpg",
///     "video_url": "https://gurutechnolabs.co.in/website/laravel/meditation/public/video/Video_2_49607.mp4"
///   }
/// }
library;

import 'package:meditation_app/data/model/response/pdfs_response.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';


class BookmarkListResponse {
  int? id;
  int? userId;
  int? videoId;
  String? videoTitle;
  String? createdAt;
  String? updatedAt;
  VideoResponse? bookmarkVideoResponse;

  BookmarkListResponse({this.id, this.userId, this.videoId, this.videoTitle, this.createdAt, this.updatedAt, this.bookmarkVideoResponse});

  BookmarkListResponse.fromJson(dynamic json, bool isFromAudio) {
    id = json['id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['video'] != null) {
      videoTitle = json['video_title'];
      videoId = json['video_id'];
      bookmarkVideoResponse = VideoResponse.fromJson(json['video'], false);
    } else if (json['audio'] != null) {
      videoId = json['audio_id'];
      videoTitle = json['audio_title'];
      bookmarkVideoResponse = VideoResponse.fromJson(json['audio'], true);
    }
  }

  static List<BookmarkListResponse> listFromJson(dynamic jsonList, bool isFromAudio) {
    List<BookmarkListResponse> list = [];
    for (var json in jsonList) {
      list.add(BookmarkListResponse.fromJson(json, isFromAudio));
    }
    return list;
  }
}

class BookmarkVideoResponse {
  int? id;
  String? title;
  String? thumbnailImageUrl;
  String? videoUrl;

  BookmarkVideoResponse({this.id, this.title, this.thumbnailImageUrl, this.videoUrl});

  BookmarkVideoResponse.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    thumbnailImageUrl = json['thumbnail_image_url'];
    videoUrl = json['video_url'];
  }
}


class BookmarkPDFListResponse {
  int? id;
  int? userId;
  int? pdfId;
  String? pdfTitle;
  String? createdAt;
  String? updatedAt;
  PdfResponse? bookmarkPdfResponse;

  BookmarkPDFListResponse({this.id, this.userId, this.pdfId, this.pdfTitle, this.createdAt, this.updatedAt, this.bookmarkPdfResponse});

  BookmarkPDFListResponse.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['pdf'] != null) {
      pdfTitle = json['pdf_title'];
      pdfId = json['pdf_id'];
      bookmarkPdfResponse = PdfResponse.fromJson(json['pdf']);
    }
  }

  static List<BookmarkPDFListResponse> listFromJson(dynamic jsonList, bool isFromAudio) {
    List<BookmarkPDFListResponse> list = [];
    for (var json in jsonList) {
      list.add(BookmarkPDFListResponse.fromJson(json));
    }
    return list;
  }
}
