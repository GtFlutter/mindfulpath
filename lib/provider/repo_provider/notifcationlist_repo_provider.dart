import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/repositories/notification_repo.dart';
import 'package:meditation_app/data/repositories/playlist_repo.dart';
import 'package:meditation_app/provider/base/api_client_provider.dart';
import 'package:meditation_app/provider/base/shared_preferences_provider.dart';

final notificationListRepoProvider = Provider<NotificationRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  final repository = NotificationRepo(apiClient);
  return repository;
});