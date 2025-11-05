import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final internetProvider = StateNotifierProvider<InternetNotifier, bool>((ref) {
  return InternetNotifier();
});

class InternetNotifier extends StateNotifier<bool> {
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  InternetNotifier() : super(true) {
    _init();
  }

  Future<void> _init() async {
    await _checkInternet();

    _subscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        print('Stream event fired: $results');
        await _checkInternet();
      },
    );
  }

  Future<bool> _checkInternet() async {
    bool connected = false;

    try {
      // check connectivity type
      final results = await _connectivity.checkConnectivity();
      print('Connectivity results:--------> $results');
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        // now verify internet reachability
        final lookup = await InternetAddress.lookup('example.com').timeout(const Duration(seconds: 2));
        if (lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty) {
          connected = true;
        }
      }
    } catch (_) {
      connected = false;
    }

    // ✅ Force Riverpod to rebuild only if changed
    if (state != connected) {
      state = connected;
    }
    return connected;
  }

  Future<bool> checkNow() async {
    final res=await _checkInternet();
    return res;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
