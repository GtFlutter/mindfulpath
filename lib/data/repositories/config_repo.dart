import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/data/model/support_ticket_body_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_config.dart';

class ConfigRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  ConfigRepo(this.apiClient, this.sharedPreferences);

  Future<Response> getStaticPageData() async {
    return await apiClient.getData(AppConfigs.getStaticPageData);
  }

  Future<Response> raiseSupportTicket(SupportTicket ticket) async {
    return await apiClient.postData(AppConfigs.raiseSupportTicket, ticket.toJson);
  }

  Future<Response> getSupportTicketsList() async {
    return await apiClient.getData(AppConfigs.getSupportTicketsList);
  }

  Future<Response> notificationToggle() async {
    return await apiClient.getData(AppConfigs.notificationToggle);
  }
}
