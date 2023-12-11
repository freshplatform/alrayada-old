import '/data/my_app_notification/m_my_app_notification.dart';

import '../../services/native/database/s_sqlite.dart';

class MyAppNotificationService {
  static const tableName = 'notification';
  MyAppNotificationService._privateConstructor();

  static final _sqliteService = SqliteService.instance;

  static Future<int> addNotification(MyAppNotification notification) async {
    final db = await _sqliteService.database;
    final result = await db.insert(tableName, notification.toMap());
    await _sqliteService.closeDatabase();
    return result;
  }

  static Future<int> removeNotificationByMessageId(String messageId) async {
    final db = await _sqliteService.database;
    final result = await db.delete(
      tableName,
      where: 'messageId = ?',
      whereArgs: [messageId],
    );
    await _sqliteService.closeDatabase();
    return result;
  }

  static Future<int> removeAllNotifications() async {
    final db = await _sqliteService.database;
    final result = await db.delete(tableName);
    await _sqliteService.closeDatabase();
    return result;
  }

  static Future<List<MyAppNotification>> getItems() async {
    final db = await _sqliteService.database;
    final items = await db.query(tableName, orderBy: 'createdAt DESC');
    await _sqliteService.closeDatabase();
    if (items.isEmpty) {
      return [];
    }
    final cartItems = items.map((e) => MyAppNotification.fromMap(e)).toList();
    return cartItems;
  }
}
