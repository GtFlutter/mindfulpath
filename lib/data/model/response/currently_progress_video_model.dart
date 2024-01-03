// {
//   "status": true,
//   "message": "Category list",
//   "data": {
//     "category_list": [
//       {
//         "id": 2,
//         "user_id": "3",
//         "video_id": "2",
//         "category_id": "2",
//         "duration": 30,
//         "play_date": "2023-10-11",
//         "created_at": "2023-08-09T11:48:23.000000Z",
//         "updated_at": "2023-08-16T05:46:01.000000Z",
//         "title": "Ketogenic",
//         "button_title": "Diet",
//         "price": "1",
//         "category": {
//           "id": 2,
//           "title": "Ketogenic",
//           "button_title": "Diet",
//           "price": "1",
//           "created_at": "2023-08-09T11:48:23.000000Z",
//           "updated_at": "2023-08-16T05:46:01.000000Z",
//           "image": {
//             "id": 13,
//             "type_id": "2",
//             "file_name": "Category_2_85140.jpg",
//             "type": "category_image",
//             "image_url": "https:\/\/gurutechnolabs.co.in\/website\/laravel\/meditation\/public\/category_image\/Category_2_85140.jpg"
//           }
//         }
//       }
//     ],
//     "current_page": 1,
//     "per_page": 10,
//     "total": 1,
//     "last_page": 1
//   }
// }
import 'package:meditation_app/data/model/response/category_list_reponse.dart';

class CPVideoResponse {
  final num? id;
  final num? userId;
  final num? videoId;
  final num? categoryId;
  final num? duration;
  final String? playDate;
  final String? createdAt;
  final String? updatedAt;
  final String? title;
  final String? buttonTitle;
  final String? price;
  final CategoryListResponse? categoryResponse;

  CPVideoResponse(
      {this.id,
      this.userId,
      this.videoId,
      this.categoryId,
      this.duration,
      this.playDate,
      this.createdAt,
      this.updatedAt,
      this.title,
      this.buttonTitle,
      this.price,
      this.categoryResponse});

  factory CPVideoResponse.fromJson(dynamic json) {
    return CPVideoResponse(
      id: json['id'],
      userId: num.parse(json['user_id'].toString()),
      videoId: num.parse(json['video_id'].toString()),
      categoryId: num.parse(json['category_id'].toString()),
      duration: num.parse(json['duration'].toString()),
      playDate: json['play_date'],
      title: json['title'],
      price: json['price'],
      buttonTitle: json['button_title'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryResponse: json['category'] == null ? null : CategoryListResponse.fromJson(json['category']),
    );
  }

  static List<CPVideoResponse> listFromJson(dynamic jsonList) {
    List<CPVideoResponse> list = [];
    for (var json in jsonList) {
      list.add(CPVideoResponse.fromJson(json));
    }
    return list;
  }
}