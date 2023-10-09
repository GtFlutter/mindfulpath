// {
// "status": true,
// "message": "Playlist list",
// "data": {
// "palylist": [
// {
// "id": 1,
// "user_id": 2,
// "title": "Honey Sing",
// "created_at": "2023-10-09T12:33:54.000000Z",
// "updated_at": "2023-10-09T12:33:54.000000Z"
// }
// ],
// "current_page": 1,
// "per_page": 10,
// "total": 1,
// "last_page": 1
// }
// }

class PlaylistListResponse {
  num? id;
  num? userId;
  String? title;
  String? createdAt;
  String? updatedAt;

  PlaylistListResponse({this.id, this.userId, this.title, this.createdAt, this.updatedAt});

  PlaylistListResponse.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  static List<PlaylistListResponse> listFromJson(dynamic jsonList) {
    List<PlaylistListResponse> list = [];
    for (var json in jsonList) {
      list.add(PlaylistListResponse.fromJson(json));
    }
    return list;
  }

}