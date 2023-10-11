import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/ui/screens/analytics/data/repo/analytics_repo.dart';

import '../../../../../provider/base/api_client_provider.dart';

final analyticsRepoProvider = Provider<AnalyticsRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return AnalyticsRepo(apiClient: apiClient);
});
