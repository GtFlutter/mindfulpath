import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/ui/screens/category/widget/download_detail_item.dart';
import '../data/model/body/resource_type.dart';
import '../helper/route/route_paths.dart';
import '../ui/common/custom_snackbar.dart';
import '../ui/screens/category/widget/detail_item.dart';
import 'auth_provider.dart';
import 'recent_videos_provider.dart';

final videoProvider = ChangeNotifierProvider<VideoNotifier>((ref) {
  return VideoNotifier(ref);
});

class VideoNotifier extends ChangeNotifier {
  final ChangeNotifierProviderRef<VideoNotifier> _ref;
  VideoNotifier(this._ref);
  DIModel? _video;
  DIModel? get video => _video;
  int? isSelected;


  void reInit([DetailedVideoModel? detailedVideoModel]) {
    if (detailedVideoModel == null) {
      return;
    }
    playVideo(detailedVideoModel, notifie: true, forceToPlay: true);
  }

  void playVideo(DetailedVideoModel detailedVideoModel, {bool notifie = true, bool forceToPlay = false,int? index}) {
    /// Auth User
    bool isLoggedIn = _ref.read(authProvider).isUserLoggedIn;
    if (detailedVideoModel.video.videoType == ResourceType.paid && !isLoggedIn) {
      showCustomSnackBar('Login to access video', type: false);
      appRouter.push(RoutePath.signIn);
      return;
    }

    /// If Video Already Playing Then Don't Chanage Video
    /// Also If Video Playing Is Same Requested Video Then Don't Chnage Video
    /// If It's Want to faorce to play video then just play video
    DIModel? model = _video?.copyWith();
    if ((model == null || model.videoId != detailedVideoModel.videoId) || forceToPlay) {
      _video = detailedVideoModel.video.copyWith();
      isSelected = index;
      if (notifie) notifyListeners();
      // showCustomSnackBar('New Video Set Video Name: ${_video!.title}', type: true);
      _ref.read(recentVideosProvider).addRecentVideo(detailedVideoModel);
    } else {
      // showCustomSnackBar('Errorororo', type: false);
    }
  }

  void clearVideo({bool notifie = true}) {
    _video = null;
    if (notifie) notifyListeners();
  }
}

final offlineVideoProvider = ChangeNotifierProvider<OfflineVideoNotifier>((ref) => OfflineVideoNotifier());

class OfflineVideoNotifier extends ChangeNotifier {
  DDIModal? _video;
  DDIModal? get video => _video;

  void reInit([DDIModal? ddiModal]) {
    if (ddiModal == null) {
      return;
    }
    playVideo(ddiModal, forceToPlay: true);
  }

  void playVideo(DDIModal ddiModal, {bool notify = true, bool forceToPlay = false}) {

    DDIModal? model = _video;
    if ((model == null || model.videoId != ddiModal.videoId) || forceToPlay) {
      _video = ddiModal;
      if (notify) notifyListeners();
    }
  }

  void clearVideo({bool notify = true}) {
    _video = null;
    if (notify) notifyListeners();
  }
}
