import 'package:flutter/foundation.dart';

abstract class VideoResourceNotifier with ChangeNotifier {
  void toggleBookmark(int itemId, {bool notifier = true});
  void startLoading();
  void stopLoading();
  Future<void> fetchVideos(int categoryId);
}
