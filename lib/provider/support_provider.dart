import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/model/support_ticket_body_model.dart';
import 'package:meditation_app/data/repositories/config_repo.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/provider/repo_provider/config_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';

import '../data/api/api_checker.dart';
import '../data/model/response/error_res_model.dart';
import '../data/model/response/response_error.dart';
import '../helper/route/route_paths.dart';
import '../util/constants.dart';

final supportProvider = ChangeNotifierProvider<SupportNotifier>((ref) {
  final configRepo = ref.watch(configRepoProvider);
  return SupportNotifier(configRepo);
});

class SupportNotifier extends ChangeNotifier {
  final ConfigRepo repo;

  SupportNotifier(this.repo);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? name;
  String? email;
  String? descr;

  void startLoading() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void stopLoading() {
    if (isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? _nameErrorText;
  String? _emailErrorText;
  String? _descriptionErrorText;

  String? get nameErrorText => _nameErrorText;

  String? get emailErrorText => _emailErrorText;

  String? get descriptionErrorText => _descriptionErrorText;

  void clearAllErrorText({bool notifie = true}) {
    _nameErrorText = null;
    _emailErrorText = null;
    _descriptionErrorText = null;
    if (notifie) notifyListeners();
  }

  void setNameError({String? error, bool notifie = true}) {
    if (error == null && _nameErrorText == null) {
      return;
    }
    _nameErrorText = error;
    if (notifie) notifyListeners();
  }

  void setEmailError({String? error, bool notifie = true}) {
    if (error == null && _emailErrorText == null) {
      return;
    }
    _emailErrorText = error;
    if (notifie) notifyListeners();
  }

  void setDescriptionError({String? error, bool notifie = true}) {
    if (error == null && _descriptionErrorText == null) {
      return;
    }
    _descriptionErrorText = error;
    if (notifie) notifyListeners();
  }

  Future<void> raiseSupportTicket(SupportTicket ticket, {required TextEditingController nameCtrl, emailCtrl, descriptionCtrl}) async {
    startLoading();

    Response response = await repo.raiseSupportTicket(ticket);
    if (response.statusCode == 200) {
      stopLoading();
      showCustomSnackBar('Ticket Submitted Successfully.', type: true);
      try {
        nameCtrl.clear();
        emailCtrl.clear();
        descriptionCtrl.clear();
      } catch (_) {}
      BuildContext? context = rootNavigator.currentContext;
      if (context != null && context.mounted) {
        // context.go(RoutePath.supportSectionScreenPath);
        context.pop(true);
      }
      return;
    }

    try {
      final json = jsonDecode(response.body);
      if (response.statusCode == 403 && json['data'] != null) {
        RaiseSupportResponseErrorModel errorModel = RaiseSupportResponseErrorModel.fromJson(json['data']);
        if (errorModel.name.isNotEmpty) setNameError(error: errorModel.name.first, notifie: false);
        if (errorModel.email.isNotEmpty) setEmailError(error: errorModel.email.first, notifie: false);
        if (errorModel.description.isNotEmpty) setDescriptionError(error: errorModel.description.first, notifie: false);
        stopLoading();
        return;
      }
    } catch (_) {}
    stopLoading();
    ApiChecker.checkApi(response);
    _popScreenIfAvailable();
  }

  void _popScreenIfAvailable() {
    BuildContext? context = rootNavigator.currentContext;
    if (context != null && context.mounted && context.canPop()) {
      context.pop();
    }
  }
}

class RaiseSupportResponseErrorModel {
  final List<String> name;
  final List<String> email;
  final List<String> description;

  RaiseSupportResponseErrorModel({
    required this.name,
    required this.email,
    required this.description,
  });

  factory RaiseSupportResponseErrorModel.fromJson(Map<String, dynamic> json) {
    return RaiseSupportResponseErrorModel(
      name: json['name'] == null ? [] : json['name'].cast<String>(),
      email: json['email'] == null ? [] : json['email'].cast<String>(),
      description: json['description'] == null ? [] : json['description'].cast<String>(),
    );
  }
}

final supportTicketsListProvider = FutureProvider<List<SupportTicket>>((ref) async {
  var repo = ref.read(configRepoProvider);

  Response response = await repo.getSupportTicketsList();

  try {
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['data']['contact_support'] as List<dynamic>?;
      final list = json != null ? SupportTicket.listFromJson(json) : <SupportTicket>[];
      if (list.isNotEmpty) {
        return list;
      }
      throw ResponseError(response.statusCode, 'No data found!');
    } else {
      final body = jsonDecode(response.body);
      final error = ErrorResponse.fromJson(body);
      final errorMessage = error.message ?? AppConstants.WENT_WRONG;
      throw ResponseError(response.statusCode, errorMessage);
    }
  } catch (e) {
    if (e is ResponseError) {
      rethrow;
    }
    throw ResponseError(500, AppConstants.WENT_WRONG);
  }
});
