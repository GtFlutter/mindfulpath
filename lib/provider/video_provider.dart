import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/helper/route/router.dart';
import '../data/model/body/resource_type.dart';
import '../helper/route/route_paths.dart';
import '../ui/common/custom_snackbar.dart';
import '../ui/screens/category/widget/detail_item.dart';
import 'auth_provider.dart';

final videoProvider = ChangeNotifierProvider<VideoNotifier>((ref) {
  return VideoNotifier(ref);
});

class VideoNotifier extends ChangeNotifier {
  final ChangeNotifierProviderRef<VideoNotifier> _ref;
  VideoNotifier(this._ref);
  DIModel? _video;
  DIModel? get video => _video;

  void reinit([DIModel? video]) {
    if (video == null) {
      clearVideo(notifie: false);
    } else {
      playVideo(video, notifie: false, forceToPlay: true);
    }
  }

  void playVideo(DIModel video, {bool notifie = true, bool forceToPlay = false}) {
    /// Auth User
    bool isLoggedIn = _ref.read(authProvider).isUserLoggedIn;
    if (video.videoType == ResourceType.paid && !isLoggedIn) {
      showCustomSnackBar('Login to access video', type: false);
      appRouter.go(RoutePath.signIn);
      return;
    }

    /// If Video Already Playing Then Don't Chnage Video
    /// Also If Video Playing Is Same Requested Video Then Don't Chnage Video
    /// If It's Want to faorce to play video then just play video
    DIModel? model = _video?.copyWith();
    if ((model == null || model.videoId != video.videoId) || forceToPlay) {
      _video = video.copyWith();
      if (notifie) notifyListeners();
    }
  }

  void clearVideo({bool notifie = true}) {
    _video = null;
    if (notifie) notifyListeners();
  }
}
