import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/util/app_config.dart';


class NotificationRepo {
  final ApiClient apiClient;

  NotificationRepo(this.apiClient);

  Future<Response> getNotification() async {
    return await apiClient.getNotificationData(AppConfigs.getNotification);
  }

  Future<Response> getReadNotification() async {
    return await apiClient.getNotificationData(AppConfigs.getReadNotification);
  }


}
