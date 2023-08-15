import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/repositories/dashboard_repo.dart';
import 'package:meditation_app/provider/base/api_client_provider.dart';
import 'package:meditation_app/provider/base/shared_preferences_provider.dart';

final dashboardRepoProvider = Provider<DashboardRepo>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  final apiClient = ref.watch(apiClientProvider);

  final repository = DashboardRepo(apiClient, sharedPreferences);
  return repository;
});