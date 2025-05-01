import 'package:flutter/foundation.dart';

abstract class AudioResourceNotifier with ChangeNotifier {
  void toggleBookmark(int itemId, {bool notifier = true});
  void startLoading();
  void stopLoading();
  Future<void> fetchAudios(int categoryId);
}

abstract class AllResourceNotifier with ChangeNotifier {
  void toggleBookmark(int itemId, {bool notifier = true});
  void startLoading();
  void stopLoading();
  Future<void> fetchAudios(int categoryId);
  Future<void> fetchVideos(int categoryId);
  Future<void> fetchPDFs(int categoryId);
}
