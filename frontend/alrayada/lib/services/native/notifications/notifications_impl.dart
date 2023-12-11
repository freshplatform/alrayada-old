import 'package:alrayada/utils/platform_checker.dart';
import 'package:alrayada/widgets/adaptive/messenger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

import '../../../data/my_app_notification/m_my_app_notification.dart';
import '../../../providers/p_notification.dart';
import 'notifications.dart';

class NotificationsImpl extends Notifications {
  @override
  Future<UserDeviceNotificationsToken> getUserDeviceToken() async {
    var newFirebaseToken = '';
    var newOneSignalToken = '';

    try {
      newOneSignalToken = OneSignal.User.pushSubscription.id ?? '';
    } catch (e) {
      // Error
    }

    return UserDeviceNotificationsToken(
      firebase: newFirebaseToken,
      oneSignal: newOneSignalToken,
    );
  }

  @override
  Future<void> registerNotificationsHandlers(
      BuildContext context, WidgetRef ref) async {
    if (!PlatformChecker.isMobileDevice()) return;

    OneSignal.Notifications.addClickListener((event) {
      // ref
      //     .read(NotificationNotififer.notificationsProvider.notifier)
      //     .addNotificationFromPushNotification(
      //       MyAppNotification.fromOneSignal(event.notification),
    });
    foregroundWillDisplayListener(OSNotificationWillDisplayEvent event) {
      print('On foreground will display listener');
      ref
          .read(NotificationNotififer.notificationsProvider.notifier)
          .addNotificationFromPushNotification(
            MyAppNotification.fromOneSignal(event.notification),
          );
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
