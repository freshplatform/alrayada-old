import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/data/my_app_notification/s_my_app_notification.dart';
import '../data/my_app_notification/m_my_app_notification.dart';

enum NotificationLastAction { addOne, removeOne, loadAll, removeAll, none }

class NotificationNotififer extends StateNotifier<List<MyAppNotification>> {
  NotificationNotififer() : super([]);

  static final notificationsProvider =
      StateNotifierProvider<NotificationNotififer, List<MyAppNotification>>(
          (ref) => NotificationNotififer());

  var lastAction = NotificationLastAction.none;

  Future<void> addNotification(MyAppNotification myAppNotification) async {
    final exists = state
            .where(
                (element) => element.messageId == myAppNotification.messageId)
            .firstOrNull !=
        null;
    if (exists) {
      // The reasons we are checking if it exists, because there are diffrent handlers
      // and it might both has been called so it better to check first
      return;
    }
    await MyAppNotificationService.addNotification(myAppNotification);
    lastAction = NotificationLastAction.addOne;
    state = [...state, myAppNotification];
  }

  Future<void> addNotificationFromPushNotification(
      MyAppNotification myAppNotification) async {
    if (myAppNotification.messageId.isEmpty) return;
    await addNotification(myAppNotification);
  }

  Future<void> removeNotificationByMessageId(String messageId) async {
    await MyAppNotificationService.removeNotificationByMessageId(messageId);
    final modified = [...state]
      ..removeWhere((element) => element.messageId == messageId);
    lastAction = NotificationLastAction.removeOne;
    state = [...modified];
  }

  Future<void> removeAllNotifications() async {
    await MyAppNotificationService.removeAllNotifications();
    lastAction = NotificationLastAction.removeAll;
    state = [];
  }

  Future<void> loadAllNotifications() async {
    final notifications = await MyAppNotificationService.getItems();
    if (notifications.isEmpty) return;
    final modified = [];
    modified.addAll(notifications);
    lastAction = NotificationLastAction.loadAll;
    state = [...modified];
  }
}
