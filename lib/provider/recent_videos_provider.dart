import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/base/shared_preferences_provider.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/response/category_list_reponse.dart';

class DetailedVideoModel {
  int get videoId => video.videoId;
  int get catrgoryId => video.videoId;
  final CategoryListResponse category;
  final DIModel video;

  const DetailedVideoModel({required this.category, required this.video});

  factory DetailedVideoModel.fromJson(dynamic json) {
    return DetailedVideoModel(
      category: CategoryListResponse.fromJson(json['category']),
      video: DIModel.fromJson(json['video']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = video.toJson();
    data['video'] = category.toJson();
    return data;
  }

  static List<DetailedVideoModel>? listFromJson(dynamic json) {
    return (json['list'] as List<dynamic>?)?.map(DetailedVideoModel.fromJson).toList();
  }

  static Map<String, dynamic> listToJson(List<DetailedVideoModel> list) {
    Map<String, dynamic> data = {};
    data['list'] = List.generate(list.length, (index) => list[index].toJson());
    return data;
  }
}

final recentVideosProvider = ChangeNotifierProvider<RecentVideosNotifier>((ref) {
  final repo = ref.watch(sharedPreferencesProvider);

  return RecentVideosNotifier(repo);
});

class RecentVideosNotifier extends ChangeNotifier {
  final SharedPreferences prefs;
  final String prefsKey = AppConfigs.RECENT_VIDEOS;

  RecentVideosNotifier(this.prefs) {
    if (prefs.containsKey(prefsKey)) {
      String? response = prefs.getString(prefsKey);
      if (response != null) {
        List<DetailedVideoModel>? data = DetailedVideoModel.listFromJson(jsonDecode(response));
        if (data != null && data.isNotEmpty) {
          _list.addAll(data);
        }
      }
    }
  }

  List<DetailedVideoModel> _list = [];
  List<DetailedVideoModel> get list => _list;

  void addRecentVideo(DetailedVideoModel video) async {
    _list.removeWhere((element) => element.videoId == video.videoId);
    if (_list.length >= 10) {
      _list = _list.sublist(_list.length - 9);
    }
    _list.add(video);
    notifyListeners();
    var json = DetailedVideoModel.listToJson(_list);
    await prefs.setString(prefsKey, jsonEncode(json));
  }
}
