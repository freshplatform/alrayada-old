import 'dart:io' show Directory;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sqflite/sqflite.dart';

import '../../../data/my_app_notification/s_my_app_notification.dart';
import '/data/cart/s_cart.dart';
import '/data/favorite/s_favorite.dart';

class SqliteService {
  SqliteService._privateConstructor();

  static final SqliteService instance = SqliteService._privateConstructor();
  static Database? _database;

  static const databaseName = 'app.db';
  static const databaseVersion = 1;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final Directory documentsDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, databaseName);
    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE ${CartService.tableName}(
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          productId TEXT NOT NULL,
          quantity INTEGER NOT NULL,
          notes TEXT NOT NULL,
          createdAt INTEGER NOT NULL
        )
        ''');
    await db.execute('''
        CREATE TABLE ${FavoriteService.tableName}(
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          productId TEXT NOT NULL,
          createdAt INTEGER NOT NULL
        )
        ''');
    await db.execute('''
        CREATE TABLE ${MyAppNotificationService.tableName}(
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          messageId TEXT NOT NULL,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          imageUrl TEXT,
          data TEXT NOT NULL,
          createdAt INTEGER NOT NULL
        )
        ''');
  }

  Future<void> closeDatabase() async {
    if (_database == null || !_database!.isOpen) {
      return;
    }
    _database!.close();
    _database = null;
  }
}
