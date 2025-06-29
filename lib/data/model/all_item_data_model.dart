import 'package:meditation_app/data/model/response/pdfs_response.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';

class AllItemWidgetListResponse {
  bool? status;
  String? message;
  Data? data;

  AllItemWidgetListResponse({this.status, this.message, this.data});

  AllItemWidgetListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? isVideo;
  int? isAudio;
  int? isPdf;
  List<VideoResponse>? video;
  List<VideoResponse>? audio;
  List<PdfResponse>? pdf;

  Data(
      {this.isVideo,
        this.isAudio,
        this.isPdf,
        this.video,
        this.audio,
        this.pdf});

  Data.fromJson(Map<String


  , dynamic> json) {
    isVideo = json['is_video'];
    isAudio = json['is_audio'];
    isPdf = json['is_pdf'];
    if (json['video'] != null) {
      video = <VideoResponse>[];
      json['video'].forEach((v) {
        video!.add(new VideoResponse.fromJson(v,false));
      });
    }
    if (json['audio'] != null) {
      audio = <VideoResponse>[];
      json['audio'].forEach((v) {
        audio!.add(new VideoResponse.fromJson(v,true));
      });
    }
    if (json['pdf'] != null) {
      pdf = <PdfResponse>[];
      json['pdf'].forEach((v) {
        pdf!.add(new PdfResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_video'] = this.isVideo;
    data['is_audio'] = this.isAudio;
    data['is_pdf'] = this.isPdf;
    if (this.video != null) {
      data['video'] = this.video!.map((v) => v.toJson()).toList();
    }
    if (this.audio != null) {
      data['audio'] = this.audio!.map((v) => v.toJson()).toList();
    }
    if (this.pdf != null) {
      data['pdf'] = this.pdf!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}