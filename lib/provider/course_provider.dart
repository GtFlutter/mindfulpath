import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/response/purchased_video_response.dart';
import 'package:meditation_app/data/repositories/course_repo.dart';
import 'package:meditation_app/database/database_consts.dart';
import 'package:meditation_app/database/database_helper.dart';
import 'package:meditation_app/database/database_model.dart';
import 'package:meditation_app/provider/repo_provider/course_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

final courseProvider = ChangeNotifierProvider<CourseNotifier>((ref) {
  final repo = ref.watch(courseRepoProvider);
  return CourseNotifier(ref, repo);
});

class CourseNotifier extends ChangeNotifier {
  final CourseRepo repo;
  final ChangeNotifierProviderRef<CourseNotifier> ref;

  CourseNotifier(this.ref, this.repo);

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool _isPDFLoading = false;

  bool get isPDFLoading => _isPDFLoading;

  bool pushData = false;

  List<PurchasedVideoResponse> _purchasedVideoResponse = [];

  List<PurchasedVideoResponse> get purchasedVideoResponse => _purchasedVideoResponse;

  static late Database _db;
  final _configs = MigrationConfig(initializationScript: DatabaseConsts.initialScript, migrationScripts: []);

  Future<Database> get db async {
    _db = await openDB();
    return _db;
  }

  Future<Database> openDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'meditation_DB.db');

    return await openDatabaseWithMigration(path, _configs);
  }

  void _startLoading() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void _stopLoading() {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startPDFLoading() {
    if (!_isPDFLoading) {
      _isPDFLoading = true;
      notifyListeners();
    }
  }

  void stopPDFLoading() {
    _isPDFLoading = false;
    notifyListeners();
  }

  Future<void> getPurchasedList() async {
    _startLoading();
    Response response = await repo.getPurchasedList();
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      _stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _purchasedVideoResponse = PurchasedVideoResponse.listFromJson(json['data']['category_list']);
        _stopLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        _stopLoading();
      }
    }
  }

  List<PurchasedVideoResponse> _cpVideoResponse = [];

  List<PurchasedVideoResponse> get cpVideoResponse => _cpVideoResponse;

  Future<void> getCurrentlyProgressList() async {
    _startLoading();
    Response response = await repo.getPurchasedList();
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      _stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _cpVideoResponse = PurchasedVideoResponse.listFromJson(json['data']['category_list']);
        _stopLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        _stopLoading();
      }
    }
  }

//for video category
  List<CategoryModal> _downloadResponse = [];

  List<CategoryModal> get downloadResponse => _downloadResponse;

//for audio category
  List<CategoryModal> _downloadAudioCategoryResponse = [];

  List<CategoryModal> get downloadAudioCategoryResponse => _downloadAudioCategoryResponse;

  Future<void> getCategoryFromDatabase() async {
    _startLoading();
    List<CategoryModal> list = await ref.read(databaseProvider).getCategory();
    debugPrint('downloaded VIDEO CATEGORYIES :: ${list.length}');
    _downloadResponse = list;
    _stopLoading();
  }

  Future<void> getAudioCategoryFromDatabase() async {
    _startLoading();
    List<CategoryModal> list = await ref.read(databaseProvider).getAudioCategory();
    debugPrint('downloaded AUDIO CATEGORYIES :: ${list.length}');
    _downloadAudioCategoryResponse = list;
    _stopLoading();
  }

  List<PdfModel> _downloadPdfResponses = [];

  List<PdfModel> get downloadPdfResponses => _downloadPdfResponses;
  int index = 0;

  Future<void> getCategoryPdfFromDatabase() async {
    _startLoading();
    List<PdfModel> list = await ref.read(databaseProvider).getPdfCategory();
    print(list.length);
    index = list.length;
    print("getCategoryPdfFromDatabase====>$list");
    print("================123456=====================");
    _downloadPdfResponses = list;
    _stopLoading();
  }

  List<VideoModal> _downloadVideoResponse = [];

  List<VideoModal> get downloadVideoResponse => _downloadVideoResponse;

  List<VideoModal> _downloadAudioResponse = [];

  List<VideoModal> get downloadAudioResponse => _downloadAudioResponse;

  Future<void> getVideoFromDatabase(int categoryId) async {
    _startLoading();
    _downloadVideoResponse.clear();
    List<VideoModal> list = await ref.read(databaseProvider).getVideo(categoryId);
    _downloadVideoResponse.addAll(list);
    _stopLoading();
  }

  Future<void> getAudioFromDatabase(int categoryId) async {
    _startLoading();
    _downloadAudioResponse.clear();
    List<VideoModal> list = await ref.read(databaseProvider).getAudio(categoryId);
    _downloadAudioResponse.addAll(list);
    _stopLoading();
  }

  final List<PdfModel> _downloadPdfResponse = [];

  List<PdfModel> get downloadPdfResponse => _downloadPdfResponse;

  final List<PdfModel> _downloadPdfResponseTemp = [];

  List<PdfModel> get downloadPdfResponseTemp => _downloadPdfResponseTemp;

  Future<void> getPdfFromDatabase(int id) async {
    _startLoading();
    List<PdfModel> list = [];
    list = await ref.read(databaseProvider).getPdf(id);
    _downloadPdfResponse.addAll(list);
    notifyListeners();
    log("Length ${list.length}---");
    log("Length Of PDF : ${_downloadPdfResponse.length}");
    _stopLoading();
  }

  Future<void> getPdfFromDatabaseTemp() async {
    log("1st time called......");
    _downloadPdfResponse.clear();
    _downloadPdfResponseTemp.clear();
    _downloadPdfResponses.clear();
    // notifyListeners();
    // _startLoading();
    await getCategoryPdfFromDatabase();
    for (final category in _downloadPdfResponses) {
      List<PdfModel> list = [];
      list = await ref.read(databaseProvider).getPdf(category.categoryId ?? 0);
      _downloadPdfResponseTemp.addAll(list);
      log("Length ${list.length}---");
    }
    // _stopLoading();
    _downloadPdfResponse.addAll(_downloadPdfResponseTemp);
    notifyListeners();
    log("Length Of PDF : ${_downloadPdfResponse.length}");
  }

  Future<void> deleteVideo(int videoId, BuildContext context) async {
    var dbClient = await db;
    final result = await dbClient.delete(
      DatabaseConsts.videoTable,
      where: 'video_id = ?',
      whereArgs: [videoId],
    );
    if (result == 1 && downloadVideoResponse.length == 1) {
      //Navigator.popUntil(context, ModalRoute.withName(RoutePath.libraryScreen));
      // Navigator.pushReplacementNamed(context,RoutePath.coursesListScreen);
      Navigator.pop(context);
    }
  }

  Future<void> deleteAudio(int videoId, BuildContext context) async {
    var dbClient = await db;
    final result = await dbClient.delete(
      DatabaseConsts.audioTable,
      where: 'video_id = ?',
      whereArgs: [videoId],
    );
    if (result == 1 && downloadAudioResponse.length == 1) {
      //Navigator.popUntil(context, ModalRoute.withName(RoutePath.libraryScreen));
      // Navigator.pushReplacementNamed(context,RoutePath.coursesListScreen);
      Navigator.pop(context);
    }
  }

  Future<void> deleteCategoryVideo(int categoryId, BuildContext context) async {
    var dbClient = await db;
    final result = await dbClient.delete(
      DatabaseConsts.categoryTable,
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  Future<void> deleteCategoryAudio(int categoryId, BuildContext context) async {
    var dbClient = await db;
    final result = await dbClient.delete(
      DatabaseConsts.audioCategoryTable,
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  Future<void> deleteCategoryPdf(int categoryId, BuildContext context) async {
    var dbClient = await db;
    final result = await dbClient.delete(
      DatabaseConsts.categoryPdfTable,
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  Future<void> deletePdf(int pdfId, BuildContext context) async {
    var dbClient = await db;
    final result = await dbClient.delete(
      DatabaseConsts.pdfTable,
      where: 'pdf_id = ?',
      whereArgs: [pdfId],
    );
  }
}
