import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show Response;
import 'package:meditation_app/data/model/response/pdfs_response.dart';
import 'package:meditation_app/provider/resource_provider/pdf_resource_notifier_model.dart';
import '../../data/api/api_checker.dart';
import '../../data/model/body/resource_type.dart';
import '../../data/repositories/dashboard_repo.dart';
import '../../database/database_model.dart';
import '../../ui/common/custom_snackbar.dart';
import '../../util/constants.dart';
import '../repo_provider/dashboard_repo_provider.dart';

final paidPdfsProvider = ChangeNotifierProvider<PaidPdfsNotifier>((ref) {
  final repo = ref.watch(dashboardRepoProvider);
  return PaidPdfsNotifier(repo);
});

class PaidPdfsNotifier extends PdfResourceNotifier {
  final DashboardRepo repo;
  PaidPdfsNotifier(this.repo);

  PdfsResponse? _pdfsResponse;
  PdfsResponse? get pdfsResponse => _pdfsResponse;

  List<PdfModel> downloadedPDF=[];


  bool _loading = false;
  bool get loading => _loading;
  @override
  void startLoading() {
    _loading = true;
    notifyListeners();
  }

  @override
  void stopLoading() {
    _loading = false;
    notifyListeners();
  }

  @override
  Future<void> fetchPdfs(int categoryId) async {
    startLoading();
    Response response = await repo.getPdfs(categoryId: categoryId, offset: 1, resourceType: ResourceType.paid);
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _pdfsResponse = PdfsResponse.fromJson(json['data']);
        stopLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }
}
