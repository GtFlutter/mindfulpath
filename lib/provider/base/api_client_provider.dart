import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api/api_client.dart';
import '../../util/app_config.dart';
import 'shared_preferences_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);

  final apiClient = ApiClient(appBaseUrl: AppConfigs.baseUrl, sharedPreferences: sharedPreferences);
  return apiClient;
});
