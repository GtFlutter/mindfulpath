import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repo.dart';
import '../base/shared_preferences_provider.dart';
import '../base/api_client_provider.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);

  final apiClient = ref.watch(apiClientProvider);

  final respository = AuthRepo(apiClient: apiClient, sharedPreferences: sharedPreferences);

  return respository;
});
