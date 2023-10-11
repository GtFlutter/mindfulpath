import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/util/app_config.dart';

import '../model/body/analytics_body.dart';

/// TODO : Working On Analytics Repo

class AnalyticsRepo {
  final ApiClient apiClient;

  const AnalyticsRepo({required this.apiClient});

  Future<Response> getAnalytics(AnalyticsBody body) async {
    return await apiClient.postData(AppConfigs.getStatistics, body.toJson);
  }

  Future<Response> getCategoryNamesList() async {
    return await apiClient.getData(AppConfigs.getCategoryNames);
  }

  Future<Response> getVideoNamesList(int categoryId) async {
    return await apiClient.getData('${AppConfigs.getVideoNames}/$categoryId');
  }
}
