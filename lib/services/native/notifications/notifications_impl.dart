import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../data/user/models/m_user.dart';
import '../../../utils/platform_checker.dart';
import '../../../widgets/adaptive/messenger.dart';
import 'notifications.dart';

class NotificationsImpl extends Notifications {
  @override
  Future<UserDeviceNotificationsToken> getUserDeviceToken() async {
    var newFirebaseToken = '';
    var newOneSignalToken = '';

    try {
      newOneSignalToken = OneSignal.User.pushSubscription.id ?? '';
      newFirebaseToken = await FirebaseMessaging.instance.getToken() ?? '';
    } catch (e) {
      // Error
    }

    return UserDeviceNotificationsToken(
      firebase: newFirebaseToken,
      oneSignal: newOneSignalToken,
    );
  }

  @override
  Future<void> registerNotificationsHandlers(BuildContext context) async {
    if (!PlatformChecker.isMobileDevice()) return;

    OneSignal.Notifications.addClickListener((event) {
      // ref
      //     .read(NotificationNotififer.notificationsProvider.notifier)
      //     .addNotificationFromPushNotification(
      //       MyAppNotification.fromOneSignal(event.notification),
    });
    void foregroundWillDisplayListener(OSNotificationWillDisplayEvent event) {
      print('On foreground will display listener');
      // TODO: Replace this with bloc
      // conte
      //     .read(NotificationNotififer.notificationsProvider.notifier)
      //     .addNotificationFromPushNotification(
      //       MyAppNotification.fromOneSignal(event.notification),
      //     );
      AdaptiveMessenger.showPlatformMessage(
          context: context,
          message: '${event.notification.title} in foreground');
    }

    OneSignal.Notifications.removeForegroundWillDisplayListener(
        foregroundWillDisplayListener);
    OneSignal.Notifications.addForegroundWillDisplayListener(
        foregroundWillDisplayListener);
  }
}
