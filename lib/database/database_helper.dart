import 'package:flutter/material.dart';
import 'package:meditation_app/database/database_consts.dart';
import 'package:meditation_app/database/database_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

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
      debugPrint("DATABASE:- ${DatabaseConsts.categoryTable} saved to db");
    }
    return res;
  }

  Future<int> saveVideo(VideoModal modal) async {
    var dbClient = await db;
    int res;
    try {
      res = await dbClient.insert(DatabaseConsts.videoTable, modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.categoryTable} saved to db");
    } catch (e) {
      await dbClient.delete(DatabaseConsts.videoTable);
      res = await dbClient.insert('VideoTable', modal.toJson());
      debugPrint("DATABASE:- ${DatabaseConsts.videoTable} saved to db");
    }
    return res;
  }

  Future getCategory() async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.categoryTable);
  }

  Future getVideo(int categoryId) async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query(DatabaseConsts.videoTable, where: 'category_id = ?', whereArgs: [categoryId]);
  }

}