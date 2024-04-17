import 'dart:convert';

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
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/provider/repo_provider/course_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
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

  List<CategoryModal> _downloadResponse = [];
  List<CategoryModal> get downloadResponse => _downloadResponse;

  Future<void> getCategoryFromDatabase() async {
    _startLoading();

    List<CategoryModal> list = await ref.read(databaseProvider).getCategory();
    debugPrint('VIDEO CATEGORYIES :: ${list.length}');
    _downloadResponse = list;
    _stopLoading();
  }

  List<PdfModel> _downloadPdfResponses = [];
  List<PdfModel> get downloadPdfResponses => _downloadPdfResponses;
  int index = 0;


  Future<void> getCategoryPdfFromDatabase() async {
    _startLoading();
    List<PdfModel> list = await ref.read(databaseProvider).getPdfCategory();
    print(list.length);
    index=list.length;
    print(list);
    print("================123456=====================");
    _downloadPdfResponses=list;
    _stopLoading();
  }

  List<VideoModal> _downloadVideoResponse = [];
  List<VideoModal> get downloadVideoResponse => _downloadVideoResponse;

  Future<void> getVideoFromDatabase(int categoryId) async {
    _startLoading();
    List<VideoModal> list = await ref.read(databaseProvider).getVideo(categoryId);
    _downloadVideoResponse.addAll(list);
    _stopLoading();
  }

  final List<PdfModel> _downloadPdfResponse = [];
  List<PdfModel> get downloadPdfResponse => _downloadPdfResponse;


  Future<void> getPdfFromDatabase(int id) async {
    _startLoading();
    List<PdfModel> list = await ref.read(databaseProvider).getPdf(id);
    _downloadPdfResponse.addAll(list);
    debugPrint("Length ${list.length}");
    debugPrint("Length Of PDF : ${_downloadPdfResponse.length}");
    _stopLoading();
  }

  void deleteVideo(int videoId,BuildContext context) async {
    var dbClient = await db;
    final result = await dbClient.delete(
      DatabaseConsts.videoTable,
      where: 'video_id = ?',
      whereArgs: [videoId],
    );
    if(result==1){
        //Navigator.popUntil(context, ModalRoute.withName(RoutePath.libraryScreen));
       // Navigator.pushReplacementNamed(context,RoutePath.coursesListScreen);
        Navigator.pop(context);


    }
  }

  void deleteCategoryVideo(int categoryId,BuildContext context) async {
    var dbClient = await db;
    final result = await dbClient.delete(
      DatabaseConsts.categoryTable,
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  void deleteCategoryPdf(int categoryId,BuildContext context) async {
    var dbClient = await db;
    final result = await dbClient.delete(
      DatabaseConsts.categoryPdfTable,
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  void deletePdf(int pdfId,BuildContext context) async {
    var dbClient = await db;
    final result = await dbClient.delete(
      DatabaseConsts.pdfTable,
      where: 'pdf_id = ?',
      whereArgs: [pdfId],
    );

  }

}