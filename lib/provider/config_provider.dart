import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/repositories/config_repo.dart';
import 'package:meditation_app/provider/repo_provider/config_repo_provider.dart';
import 'package:meditation_app/provider/user_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';

final configProvider = ChangeNotifierProvider<ConfigNotifier>((ref) {
  final repo = ref.watch(configRepoProvider);
  return ConfigNotifier(repo, ref);
});

class ConfigNotifier extends ChangeNotifier {
  final ConfigRepo repo;
  final ChangeNotifierProviderRef<ConfigNotifier> ref;

  ConfigNotifier(this.repo, this.ref);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void startLoading() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void stopLoading() {
    if (isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> notificationToggle() async {
    startLoading();
    Response response = await repo.notificationToggle();
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        // ignore: unused_result
        await ref.refresh(getUserProfileProvider.future);
        showCustomSnackBar('Notification Setting Updated Successfully');
        stopLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }
}
