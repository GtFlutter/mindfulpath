import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/repositories/notification_repo.dart';
import 'package:meditation_app/provider/repo_provider/notifcationlist_repo_provider.dart';
import 'package:meditation_app/ui/screens/notifications/NotificationResponse.dart';


final notificationListProvider = ChangeNotifierProvider<NotificationlistNotifier>((ref) {
  final repo = ref.watch(notificationListRepoProvider);

  return NotificationlistNotifier(repo);
});

class NotificationlistNotifier extends ChangeNotifier {

  NotificationRepo repo;
  NotificationlistNotifier(this.repo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationResponse? _notificationListResponse;
  NotificationResponse? get notificationListResponse => _notificationListResponse;




  void startLoading() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void stopLoading() {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getNotificationList({bool showProgress = false}) async {
    if (showProgress) startLoading();
    Response response = await repo.getNotification();
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      if (showProgress) stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _notificationListResponse = NotificationResponse.fromJson(json);
        if (showProgress) {
          stopLoading();
        } else {
          notifyListeners();
        }
      } catch (e) {
        //showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        if (showProgress) stopLoading();
      }
    }
  }

  Future<void> getReadeNotification() async {
    Response response = await repo.getReadNotification();
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        notifyListeners();

      } catch (e) {
        //showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
      }
    }
  }

}