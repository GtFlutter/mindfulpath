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
  List<CategoryModal> _downloadPdfResponses = [];

  List<CategoryModal> get downloadPdfResponses => _downloadPdfResponses;

  Future<Database> get db async {
    _db = await openDB();
    return _db;
  }

  final _configs = MigrationConfig(initializationScript: DatabaseConsts.initialScript, migrationScripts: [
    '''CREATE TABLE IF NOT EXISTS ${DatabaseConsts.audioTable} (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "video_id" TEXT,
      "thumbnail_image_url" TEXT,
      "video_name" TEXT,
      "video_file" TEXT,
      "video_duration" TEXT,
      "category_id" TEXT
    );''',
    '''CREATE TABLE IF NOT EXISTS ${DatabaseConsts.audioCategoryTable} (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "category_id" TEXT,
      "category_name" TEXT,
      "category_image" TEXT
    );''',
    '''CREATE TABLE IF NOT EXISTS ${DatabaseConsts.categoryPdfTable} (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "category_id" TEXT,
      "category_name" TEXT,
      "category_image" TEXT
    );''',
  ]);

  Future<Database> openDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'meditation_DB.db');

    return await openDatabaseWithMigration(path, _configs);
  }

  Future close() async => _db.close();

  ///==========================================================for video===================================================///
  ///save Video category
  Future<int> saveCategory(CategoryModal modal) async {
    var dbClient = await db;

    // 🔹 Ensure all fields are not null (or provide default)
    final data = modal.toJson().map((key, value) {
      if (value == null) {
        if (value is int) return MapEntry(key, 0);
        if (value is String) return MapEntry(key, '');
        return MapEntry(key, ''); // fallback
      }
      return MapEntry(key, value);
    });

    try {
      // ✅ Check if category with same id already exists
      final existing = await dbClient.query(
        DatabaseConsts.categoryTable,
        where: 'id = ?',
        whereArgs: [modal.id],
      );

      if (existing.isNotEmpty) {
        debugPrint("⚠️ Category with id ${modal.id} already exists, skipping insert");
        return 0;
      }

      int res = await dbClient.insert(DatabaseConsts.categoryTable, data);
      debugPrint("DATABASE:- ${DatabaseConsts.categoryTable} saved to db");
      return res;
    } catch (e) {
      debugPrint("DATABASE:- Error saving ${DatabaseConsts.categoryTable}: $e");
      return -1;
    }
  }

  ///save video
  Future<int> saveVideo(VideoModal modal) async {
    var dbClient = await db;

    final data = modal.toJson().map((key, value) {
      if (value == null) {
        if (value is int) return MapEntry(key, 0);
        if (value is String) return MapEntry(key, '');
        return MapEntry(key, '');
      }
      return MapEntry(key, value);
    });

    try {
      // ✅ Skip if video id already exists
      final existing = await dbClient.query(
        DatabaseConsts.videoTable,
        where: 'id = ?',
        whereArgs: [modal.id],
      );

      if (existing.isNotEmpty) {
        debugPrint("⚠️ Video with id ${modal.id} already exists, skipping insert");
        return 0;
      }

      int res = await dbClient.insert(DatabaseConsts.videoTable, data);
      debugPrint("DATABASE:- ${DatabaseConsts.videoTable} saved to db");
      return res;
    } catch (e) {
      debugPrint("DATABASE:- Error saving ${DatabaseConsts.videoTable}: $e");
      return -1;
    }
  }

  ///Get single category of Video
  Future<CategoryModal?> getSingleCategory(String categoryId) async {
    var dbClient = await db;
    List<Map<String, Object?>> res = await dbClient.query(DatabaseConsts.categoryTable, where: 'category_id = ?', whereArgs: [categoryId]);
    if (res.isNotEmpty) {
      return CategoryModal.fromJson(res.first);
    } else {
      return null;
    }
  }

  ///Get single video
  Future<VideoModal?> getSingleVideo(String videoId) async {
    var dbClient = await db;
    List<Map<String, Object?>> res = await dbClient.query(DatabaseConsts.videoTable, where: 'video_id = ?', whereArgs: [videoId]);
    if (res.isNotEmpty) {
      return VideoModal.fromJson(res.first);
    } else {
      return null;
    }
  }

  ///Get all video category
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

  ///get all video of particular category
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


  /// Get all downloaded videos across all categories
  Future<List<VideoModal>> getAllDownloadedVideos() async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.videoTable);
    debugPrint("Res getAllDownloadedVideos:: $res");
    return res.isNotEmpty ? VideoModal.listFromJson(res) : [];
  }

  /// Get all downloaded audios across all categories
  Future<List<VideoModal>> getAllDownloadedAudios() async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.audioTable);
    debugPrint("Res getAllDownloadedAudios:: $res");
    return res.isNotEmpty ? VideoModal.listFromJson(res) : [];
  }

  /// Get all downloaded PDFs across all categories
  Future<List<PdfModel>> getAllDownloadedPdfs() async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.pdfTable);
    debugPrint("Res getAllDownloadedPdfs:: $res");
    return res.isNotEmpty ? PdfModel.listFromJson(res) : [];
  }


  /// ==========================================================for pdf===================================================///
  ///save pdf category
  Future<int> savePdfCategory(CategoryModal modal) async {
    var dbClient = await db;
    int res;
    try {
      print('|||||||||||||||||||||||||||${modal.toJson()}');
      res = await dbClient.insert(DatabaseConsts.categoryPdfTable, modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.categoryPdfTable} saved to db");
    } catch (e) {
      await dbClient.delete(DatabaseConsts.categoryPdfTable);
      res = await dbClient.insert('CategoryPdfTable', modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.categoryPdfTable} saved to db with Error");
    }
    return res;
  }

  ///save pdf
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

  ///Get single pdf category
  Future<CategoryModal?> getSinglePdfCategory(String categoryId) async {
    var dbClient = await db;
    List<Map<String, Object?>> res = await dbClient.query(DatabaseConsts.categoryPdfTable, where: 'category_id = ?', whereArgs: [categoryId]);
    if (res.isNotEmpty) {
      return CategoryModal.fromJson(res.first);
    } else {
      return null;
    }
  }

  ///Get single pdf
  Future<PdfModel?> getSinglePdf(String pdfId) async {
    var dbClient = await db;
    List<Map<String, Object?>> res = await dbClient.query(DatabaseConsts.pdfTable, where: 'pdf_id = ?', whereArgs: [pdfId]);
    if (res.isNotEmpty) {
      debugPrint("Res get single pdf::: $res");
      return PdfModel.fromJson(res.first);
    } else {
      return null;
    }
  }

  ///Get all pdf category
  Future<List<CategoryModal>> getPdfCategory() async {
    List<CategoryModal> tempList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.categoryPdfTable);
    debugPrint("Res getCategory::: $res");

    if (res.isNotEmpty) {
      tempList = CategoryModal.listFromJson(res);
      _downloadPdfResponses = CategoryModal.listFromJson(res);
      return tempList;
    } else {
      return tempList;
    }
  }

  ///Get all pdf of particular category
  Future<List<PdfModel>> getPdf(int categoryId) async {
    List<PdfModel> tempList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.pdfTable, where: 'category_id = ?', whereArgs: [categoryId]);
    debugPrint("Res getPdf:: $res");
    if (res.isNotEmpty) {
      tempList = PdfModel.listFromJson(res);
      return tempList;
    } else {
      return tempList;
    }
  }

  ///==========================================================for audio===================================================///
  ///save audio category
  Future<int> saveAudioCategory(CategoryModal modal) async {
    var dbClient = await db;
    int res;
    try {
      res = await dbClient.insert(DatabaseConsts.audioCategoryTable, modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.audioCategoryTable} saved to db");
    } catch (e) {
      await dbClient.delete(DatabaseConsts.audioCategoryTable);
      res = await dbClient.insert(DatabaseConsts.audioCategoryTable, modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.audioCategoryTable} saved to db with Error");
    }
    return res;
  }

  ///save audio
  Future<int> saveAudio(VideoModal modal) async {
    var dbClient = await db;
    int res;
    try {
      res = await dbClient.insert(DatabaseConsts.audioTable, modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.audioTable} saved to db");
    } catch (e) {
      await dbClient.delete(DatabaseConsts.audioTable);
      res = await dbClient.insert('AudioTable', modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.audioTable} saved to db with Error");
    }
    return res;
  }

  ///get particular audio category
  Future<CategoryModal?> getAudioSingleCategory(String categoryId) async {
    var dbClient = await db;
    List<Map<String, Object?>> res = await dbClient.query(DatabaseConsts.audioCategoryTable, where: 'category_id = ?', whereArgs: [categoryId]);
    if (res.isNotEmpty) {
      return CategoryModal.fromJson(res.first);
    } else {
      return null;
    }
  }

  ///get all audio category
  Future<List<CategoryModal>> getAudioCategory() async {
    List<CategoryModal> tempList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.audioCategoryTable);
    debugPrint("Res getCategory:: $res");
    if (res.isNotEmpty) {
      tempList = CategoryModal.listFromJson(res);
      return tempList;
    } else {
      return tempList;
    }
  }

  ///get all audio of particular category
  Future<List<VideoModal>> getAudio(int categoryId) async {
    print("category id in database helper---$categoryId");
    List<VideoModal> tempList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.audioTable, where: 'category_id = ?', whereArgs: [categoryId]);
    print("Res getAudio:: $res");
    if (res.isNotEmpty) {
      tempList = VideoModal.listFromJson(res);
      return tempList;
    } else {
      return tempList;
    }
  }

  ///get particular audio
  Future<VideoModal?> getSingleAudio(String videoId) async {
    var dbClient = await db;
    List<Map<String, Object?>> res = await dbClient.query(DatabaseConsts.audioTable, where: 'video_id = ?', whereArgs: [videoId]);
    if (res.isNotEmpty) {
      return VideoModal.fromJson(res.first);
    } else {
      return null;
    }
  }
}
