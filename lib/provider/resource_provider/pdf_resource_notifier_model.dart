import 'package:flutter/foundation.dart';

abstract class PdfResourceNotifier with ChangeNotifier {
  void startLoading();
  void stopLoading();
  Future<void> fetchPdfs(int categoryId);
}
