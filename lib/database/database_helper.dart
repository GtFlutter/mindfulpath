import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/database/database_consts.dart';
import 'package:meditation_app/database/database_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';


final databaseProvider = Provider<DatabaseHelper>((ref) => DatabaseHelper());

class DatabaseHelper {

  static late Database _db;


  Future<Database> get db async {
    _db = await openDB();
    return _db;
  }

  final _configs = MigrationConfig(initializationScript: DatabaseConsts.initialScript, migrationScripts: []);

  Future<Database> openDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'meditation_DB.db');

    return await openDatabaseWithMigration(path, _configs);
  }

  Future close() async => _db.close();

  Future<int> saveCategory(CategoryModal modal) async {
    var dbClient = await db;
    int res;
    try {
      res = await dbClient.insert(DatabaseConsts.categoryTable, modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.categoryTable} saved to db");
    } catch (e) {
      await dbClient.delete(DatabaseConsts.categoryTable);
      res = await dbClient.insert('CategoryTable', modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.categoryTable} saved to db with Error");
    }
    return res;
  }

  Future<CategoryModal?> getSingleCategory(String categoryId) async {
    var dbClient = await db;
    List<Map<String, Object?>> res = await dbClient.query(DatabaseConsts.categoryTable, where: 'category_id = ?', whereArgs: [categoryId]);
    if (res.isNotEmpty) {
      return CategoryModal.fromJson(res.first);
    } else {
      return null;
    }
  }

  Future<VideoModal?> getSingleVideo(String videoId) async {
    var dbClient = await db;
    List<Map<String, Object?>> res = await dbClient.query(DatabaseConsts.videoTable, where: 'video_id = ?', whereArgs: [videoId]);
    if (res.isNotEmpty) {
      return VideoModal.fromJson(res.first);
    } else {
      return null;
    }
  }

  Future<PdfModel?> getSinglePdf(String pdfId) async {
    var dbClient = await db;
    List<Map<String, Object?>> res = await dbClient.query(DatabaseConsts.pdfTable, where: 'pdf_id = ?', whereArgs: [pdfId]);
    if (res.isNotEmpty) {
      return PdfModel.fromJson(res.first);
    } else {
      return null;
    }
  }

  Future<int> saveVideo(VideoModal modal) async {
    var dbClient = await db;
    int res;
    try {
      res = await dbClient.insert(DatabaseConsts.videoTable, modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.videoTable} saved to db");
    } catch (e) {
      await dbClient.delete(DatabaseConsts.videoTable);
      res = await dbClient.insert('VideoTable', modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.videoTable} saved to db with Error");
    }
    return res;
  }

  Future<int> savePDF(PdfModel modal) async {
    var dbClient = await db;
    int res;
    try {
      res = await dbClient.insert(DatabaseConsts.pdfTable, modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.pdfTable} saved to db");
    } catch (e) {
      await dbClient.delete(DatabaseConsts.pdfTable);
      res = await dbClient.insert(DatabaseConsts.pdfTable, modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.pdfTable} saved to db with Error");
    }
    return res;
  }

  Future<List<CategoryModal>> getCategory() async {
    List<CategoryModal> tempList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.categoryTable);
    debugPrint("Res getCategory:: $res");
    if (res.isNotEmpty) {
      tempList = CategoryModal.listFromJson(res);
      return tempList;
    } else {
      return tempList;
    }
  }

  Future<List<VideoModal>> getVideo(int categoryId) async {
    print("category id in database helper---$categoryId");
    List<VideoModal> tempList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.videoTable, where: 'category_id = ?', whereArgs: [categoryId]);
    debugPrint("Res getVideo:: $res");
    if (res.isNotEmpty) {
      tempList = VideoModal.listFromJson(res);
      return tempList;
    } else {
      return tempList;
    }
  }

  Future<List<PdfModel>> getPdf(int categoryId) async {
    List<PdfModel> tempList = [];
    var dbClient = await db;
    debugPrint("Category Id : $categoryId");
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.pdfTable, where: 'category_id = ?', whereArgs: [categoryId]);
    debugPrint("Res getPdf:: $res");
    if (res.isNotEmpty) {
      tempList = PdfModel.listFromJson(res);
      return tempList;
    } else {
      return tempList;
    }
  }
}