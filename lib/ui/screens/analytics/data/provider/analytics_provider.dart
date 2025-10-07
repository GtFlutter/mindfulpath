import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/body/analytics_body.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/response/analytics_result_model.dart';
import 'package:meditation_app/ui/screens/analytics/data/provider/analytics_repo_provider.dart';
import 'package:meditation_app/ui/screens/analytics/data/repo/analytics_repo.dart';

import '../../helper/analytics_enums.dart';
import '../../store_local_watch_time.dart';
import '../model/response/category_and_video_name_model.dart';

final analyticsProvider = ChangeNotifierProvider<AnalyticsNotifier>((ref) {
  var repo = ref.watch(analyticsRepoProvider);
  return AnalyticsNotifier(repo: repo, ref: ref);
});

class AnalyticsNotifier extends ChangeNotifier {
  final AnalyticsRepo repo;
  ChangeNotifierProviderRef<AnalyticsNotifier> ref;

  AnalyticsNotifier({required this.repo, required this.ref});

  bool _loading = false;

  bool get loading => _loading;

  /// TODO : Working On It
  /// TODO : Show Data From This In View
  AnalyticsResult? _result;

  AnalyticsResult? get reslut => _result;

  ItemName? _category;
  ItemName? _video;
  FilterDuration _durationtype = FilterDuration.day;
  DateTimeRange _duration = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  ItemName? get categoryId => _category;

  ItemName? get videoId => _video;

  FilterDuration get durationtype => _durationtype;

  DateTimeRange get duration => _duration;

  final List<ItemName> _categories = [];
  final List<ItemName> _videos = [];

  List<ItemName> get categories => _categories;

  List<ItemName> get videos => _videos;

  void initData({bool notifie = true}) {
    _resetCategories(notifie: false);
    _resetVideos(notifie: false);
    _setDuration(FilterDuration.day, notifie: false);
    _startLoading(notifie: false);
    if (notifie) notifyListeners();
  }

  void onCategoryChanged(ItemName? value, {bool isAudio = false}) {
    _category = value;
    _resetVideos(notifie: false);
    notifyListeners();

    if (value != null) {
      getVideoNamesList(value.id, isAudio: isAudio);
    } else {
      getAnalytics(isAudio);
    }
  }

  void onVideoChanged(ItemName? value, {bool isAudio = false}) {
    _video = value;
    notifyListeners();
    getAnalytics(isAudio);
  }

  void onDurationTypeChanged(FilterDuration? value, bool isAudio) async {
    if (value != null && value == FilterDuration.custom) {
      BuildContext? context = rootNavigator.currentContext;
      if (context != null && context.mounted) {
        DateTimeRange? range = await showDateRangePicker(
          context: context,
          lastDate: DateTime.now(),
          firstDate: DateTime.now().add(const Duration(days: -365)),
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primaryColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (range != null) {
          _duration = range;
          _durationtype = FilterDuration.custom;
          notifyListeners();
          getAnalytics(isAudio);
        }
      }
    } else {
      _setDuration(value ?? FilterDuration.day);
      getAnalytics(isAudio);
    }
  }

  void reset(bool isAudio, {bool notifie = true}) {
    _category = null;
    _resetVideos(notifie: false);
    _setDuration(FilterDuration.day, notifie: false);
    if (notifie) notifyListeners();
    getAnalytics(isAudio);
  }

  // category_list
  // video_list

  Future<void> getCategoryNamesList(bool isAudio) async {
    _resetCategories(notifie: false);
    _resetVideos(notifie: false);
    _startLoading();
    Response response = await repo.getCategoryNamesList();
    if (response.statusCode != 200) {
      _stopLoading();
      ApiChecker.checkApi(response);
      return;
    }

    try {
      var json = jsonDecode(response.body);
      if (json['data'] != null && json['data']['category_list'] != null) {
        CategoryNames names = CategoryNames.fromJson(json['data']);
        _categories.addAll(names.list);
        _stopLoading(notifie: false);
        notifyListeners();
      } else {
        throw Exception('Unable to fetch categories');
      }
    } catch (e) {
      debugPrint('$e');
      _stopLoading(notifie: false);
      _resetCategories(notifie: false);
      _resetVideos(notifie: false);
      notifyListeners();
    }

    getAnalytics(isAudio);
  }

  Future<void> getVideoNamesList(int categoryId, {bool isAudio = false}) async {
    _resetVideos(notifie: false);
    _startLoading();

    Response response = await repo.getVideoNamesList(categoryId);

    if (response.statusCode != 200) {
      _stopLoading();
      ApiChecker.checkApi(response);
      return;
    }

    try {
      var json = jsonDecode(response.body);
      if (json['data'] != null && json['data']['video_list'] != null) {
        VideoNames names = VideoNames.fromJson(json['data']);
        _videos.addAll(names.list);
        _stopLoading(notifie: false);
        notifyListeners();
      } else {
        throw Exception('Unable to fetch videoNamesList');
      }
    } catch (e) {
      debugPrint('$e');
      _stopLoading(notifie: false);
      _resetVideos(notifie: false);
      notifyListeners();
    }

    getAnalytics(isAudio);
  }

  Future<void> getAnalytics(bool isAudio) async {
    _result = null;
    _startLoading();

    // 1. Fetch server result
    Response response = await repo.getAnalytics(
      AnalyticsBody(
        categoryId: _category?.id,
        videoId: _video?.id,
        isAudio: isAudio,
        selectedType: isAudio ? AnalyticsType.audio : AnalyticsType.video,
        duration: _duration,
      ),
    );
// 2. Decode server result
    if (response.statusCode != 200) {
      _stopLoading(notifie: false);
      ApiChecker.checkApi(response);
      return;
    }

    try {
      AnalyticsResult? serverResult;
      var json = jsonDecode(response.body);
      if (json['data'] != null) {
        AnalyticsResult reslutResponse = AnalyticsResult.fromJson(json['data']);
        serverResult = reslutResponse;
        // 3. Merge offline data
        final offlineResult = await LocalAnalyticsStore.getOfflineWatchTime(_duration,isAudio: isAudio);
log("offline result---->${offlineResult.totalWatchTimeHr}");
        _result = _mergeResults(serverResult, offlineResult);
        _stopLoading(notifie: false);
        notifyListeners();
      } else {
        throw Exception('Unable to fetch result');
      }
    } catch (e) {
      debugPrint('$e');
      _result = null;
      _stopLoading(notifie: false);
      notifyListeners();
    }
  }

  AnalyticsResult _mergeResults(AnalyticsResult? server, AnalyticsResult offline) {
    if (server == null) return offline;

    // merge statistics by playDate
    final Map<String, Statistic> merged = {for (var s in server.statistics) s.playDate: s};

    for (var o in offline.statistics) {
      if (merged.containsKey(o.playDate)) {
        final prev = merged[o.playDate]!;
        merged[o.playDate] = Statistic(
          playDate: o.playDate,
          totalDurationInSecond: prev.totalDurationInSecond + o.totalDurationInSecond,
          month: o.month,
          monthName: o.monthName,
          dayName: o.dayName,
        );
      } else {
        merged[o.playDate] = o;
      }
    }

    final allStats = merged.values.toList();

    final totalSeconds = allStats.fold<int>(0, (sum, s) => sum + s.totalDurationInSecond);

    return AnalyticsResult(
      statistics: allStats,
      totalWatchTimeHr: totalSeconds / 3600.0,
      totalWatchTime: LocalAnalyticsStore.formatDuration(totalSeconds),
      totalAvgWatchTimeHr: allStats.isEmpty ? 0 : (totalSeconds / allStats.length) / 3600.0,
      avgWatchTime: allStats.isEmpty ? "00h 00m 00s" : LocalAnalyticsStore.formatDuration(totalSeconds ~/ allStats.length),
      dayDiff: server.dayDiff ?? offline.dayDiff,
    );
  }

  void _setDuration(FilterDuration type, {bool notifie = true}) {
    if (type == FilterDuration.custom) {
      return;
    }
    DateTime currentDate = DateTime.now();
    Duration addableDuration = Duration(
        days: type == FilterDuration.day
            ? 0
            : type == FilterDuration.week
                ? -6
                : type == FilterDuration.month
                    ? -29
                    : 0);
    _duration = DateTimeRange(start: currentDate.add(addableDuration), end: currentDate);
    _durationtype = type;
    if (notifie) notifyListeners();
  }

  void _resetVideos({bool notifie = true}) {
    _videos.clear();
    _video = null;
    if (notifie) notifyListeners();
  }

  void _resetCategories({bool notifie = true}) {
    _categories.clear();
    _category = null;
    if (notifie) notifyListeners();
  }

  void _startLoading({bool notifie = true}) {
    if (!_loading) {
      _loading = true;
      if (notifie) notifyListeners();
    }
  }

  void _stopLoading({bool notifie = true}) {
    if (_loading) {
      _loading = false;
      if (notifie) notifyListeners();
    }
  }
}

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart';
// import 'package:meditation_app/data/api/api_checker.dart';
// import 'package:meditation_app/helper/route/router.dart';
// import 'package:meditation_app/theme/colors.dart';
// import 'package:meditation_app/ui/screens/analytics/data/model/body/analytics_body.dart';
// import 'package:meditation_app/ui/screens/analytics/data/model/response/analytics_result_model.dart';
// import 'package:meditation_app/ui/screens/analytics/data/provider/analytics_repo_provider.dart';
// import 'package:meditation_app/ui/screens/analytics/data/repo/analytics_repo.dart';
//
// import '../../helper/analytics_enums.dart';
// import '../model/response/category_and_video_name_model.dart';
//
// final analyticsProvider = ChangeNotifierProvider<AnalyticsNotifier>((ref) {
//   var repo = ref.watch(analyticsRepoProvider);
//   return AnalyticsNotifier(repo: repo, ref: ref);
// });
//
// class AnalyticsNotifier extends ChangeNotifier {
//   final AnalyticsRepo repo;
//   ChangeNotifierProviderRef<AnalyticsNotifier> ref;
//
//   AnalyticsNotifier({required this.repo, required this.ref});
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   /// TODO : Working On It
//   /// TODO : Show Data From This In View
//   AnalyticsResult? _result;
//   AnalyticsResult? get reslut => _result;
//
//   ItemName? _category;
//   ItemName? _video;
//   FilterDuration _durationtype = FilterDuration.day;
//   DateTimeRange _duration = DateTimeRange(start: DateTime.now(), end: DateTime.now());
//
//   ItemName? get categoryId => _category;
//   ItemName? get videoId => _video;
//   FilterDuration get durationtype => _durationtype;
//   DateTimeRange get duration => _duration;
//
//   final List<ItemName> _categories = [];
//   final List<ItemName> _videos = [];
//
//   List<ItemName> get categories => _categories;
//   List<ItemName> get videos => _videos;
//
//   void initData({bool notifie = true}) {
//     _resetCategories(notifie: false);
//     _resetVideos(notifie: false);
//     _setDuration(FilterDuration.day, notifie: false);
//     _startLoading(notifie: false);
//     if (notifie) notifyListeners();
//   }
//
//   void onCategoryChanged(ItemName? value, {bool isAudio = false}) {
//     _category = value;
//     _resetVideos(notifie: false);
//     notifyListeners();
//
//     if (value != null) {
//       getVideoNamesList(value.id, isAudio: isAudio);
//     } else {
//       getAnalytics(isAudio);
//     }
//   }
//
//   void onVideoChanged(ItemName? value, {bool isAudio = false}) {
//     _video = value;
//     notifyListeners();
//     getAnalytics(isAudio);
//   }
//
//   void onDurationTypeChanged(FilterDuration? value, bool isAudio) async {
//     if (value != null && value == FilterDuration.custom) {
//       BuildContext? context = rootNavigator.currentContext;
//       if (context != null && context.mounted) {
//         DateTimeRange? range = await showDateRangePicker(
//           context: context,
//           lastDate: DateTime.now(),
//           firstDate: DateTime.now().add(const Duration(days: -365)),
//           builder: (context, child) {
//             return Theme(
//               data: ThemeData(
//                 colorScheme: const ColorScheme.dark(
//                   primary: AppColors.primaryColor,
//                 ),
//               ),
//               child: child!,
//             );
//           },
//         );
//         if (range != null) {
//           _duration = range;
//           _durationtype = FilterDuration.custom;
//           notifyListeners();
//           getAnalytics(isAudio);
//         }
//       }
//     } else {
//       _setDuration(value ?? FilterDuration.day);
//       getAnalytics(isAudio);
//     }
//   }
//
//   void reset(bool isAudio, {bool notifie = true}) {
//     _category = null;
//     _resetVideos(notifie: false);
//     _setDuration(FilterDuration.day, notifie: false);
//     if (notifie) notifyListeners();
//     getAnalytics(isAudio);
//   }
//
//   // category_list
//   // video_list
//
//   Future<void> getCategoryNamesList(bool isAudio) async {
//     _resetCategories(notifie: false);
//     _resetVideos(notifie: false);
//     _startLoading();
//     Response response = await repo.getCategoryNamesList();
//     if (response.statusCode != 200) {
//       _stopLoading();
//       ApiChecker.checkApi(response);
//       return;
//     }
//
//     try {
//       var json = jsonDecode(response.body);
//       if (json['data'] != null && json['data']['category_list'] != null) {
//         CategoryNames names = CategoryNames.fromJson(json['data']);
//         _categories.addAll(names.list);
//         _stopLoading(notifie: false);
//         notifyListeners();
//       } else {
//         throw Exception('Unable to fetch categories');
//       }
//     } catch (e) {
//       debugPrint('$e');
//       _stopLoading(notifie: false);
//       _resetCategories(notifie: false);
//       _resetVideos(notifie: false);
//       notifyListeners();
//     }
//
//     getAnalytics(isAudio);
//   }
//
//   Future<void> getVideoNamesList(int categoryId, {bool isAudio = false}) async {
//     _resetVideos(notifie: false);
//     _startLoading();
//
//     Response response = await repo.getVideoNamesList(categoryId);
//
//     if (response.statusCode != 200) {
//       _stopLoading();
//       ApiChecker.checkApi(response);
//       return;
//     }
//
//     try {
//       var json = jsonDecode(response.body);
//       if (json['data'] != null && json['data']['video_list'] != null) {
//         VideoNames names = VideoNames.fromJson(json['data']);
//         _videos.addAll(names.list);
//         _stopLoading(notifie: false);
//         notifyListeners();
//       } else {
//         throw Exception('Unable to fetch videoNamesList');
//       }
//     } catch (e) {
//       debugPrint('$e');
//       _stopLoading(notifie: false);
//       _resetVideos(notifie: false);
//       notifyListeners();
//     }
//
//     getAnalytics(isAudio);
//   }
//
//   Future<void> getAnalytics(bool isAudio) async {
//     _result = null;
//     _startLoading();
//
//     Response response = await repo.getAnalytics(
//       AnalyticsBody(
//         categoryId: _category?.id,
//         videoId: _video?.id,
//         isAudio: isAudio,
//         selectedType: isAudio ? AnalyticsType.audio : AnalyticsType.video,
//         duration: _duration,
//       ),
//     );
//
//     if (response.statusCode != 200) {
//       _stopLoading(notifie: false);
//       ApiChecker.checkApi(response);
//       return;
//     }
//
//     try {
//       var json = jsonDecode(response.body);
//       if (json['data'] != null) {
//         AnalyticsResult reslutResponse = AnalyticsResult.fromJson(json['data']);
//         _result = reslutResponse;
//         _stopLoading(notifie: false);
//         notifyListeners();
//       } else {
//         throw Exception('Unable to fetch result');
//       }
//     } catch (e) {
//       debugPrint('$e');
//       _result = null;
//       _stopLoading(notifie: false);
//       notifyListeners();
//     }
//   }
//
//   void _setDuration(FilterDuration type, {bool notifie = true}) {
//     if (type == FilterDuration.custom) {
//       return;
//     }
//     DateTime currentDate = DateTime.now();
//     Duration addableDuration = Duration(
//         days: type == FilterDuration.day
//             ? 0
//             : type == FilterDuration.week
//                 ? -6
//                 : type == FilterDuration.month
//                     ? -29
//                     : 0);
//     _duration = DateTimeRange(start: currentDate.add(addableDuration), end: currentDate);
//     _durationtype = type;
//     if (notifie) notifyListeners();
//   }
//
//   void _resetVideos({bool notifie = true}) {
//     _videos.clear();
//     _video = null;
//     if (notifie) notifyListeners();
//   }
//
//   void _resetCategories({bool notifie = true}) {
//     _categories.clear();
//     _category = null;
//     if (notifie) notifyListeners();
//   }
//
//   void _startLoading({bool notifie = true}) {
//     if (!_loading) {
//       _loading = true;
//       if (notifie) notifyListeners();
//     }
//   }
//
//   void _stopLoading({bool notifie = true}) {
//     if (_loading) {
//       _loading = false;
//       if (notifie) notifyListeners();
//     }
//   }
// }
