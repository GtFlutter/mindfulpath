import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/repositories/config_repo.dart';
import 'package:meditation_app/provider/base/api_client_provider.dart';
import 'package:meditation_app/provider/base/shared_preferences_provider.dart';

final configRepoProvider = Provider<ConfigRepo>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);

  final apiClient = ref.watch(apiClientProvider);

  final repository = ConfigRepo(apiClient, sharedPreferences);
  return repository;
});
