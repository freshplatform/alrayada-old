import 'package:alrayada/services/native/notifications/notifications.dart';
import 'package:alrayada/services/native/notifications/notifications_impl.dart';
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

class NotificationsService implements NotificationsImpl {
  NotificationsService._();
  static final instanse = NotificationsService._();
  final Notifications _service = NotificationsImpl();
  @override
  Future<UserDeviceNotificationsToken> getUserDeviceToken() =>
      _service.getUserDeviceToken();

  @override
  Future<void> registerNotificationsHandlers(
          BuildContext context, WidgetRef ref) =>
      _service.registerNotificationsHandlers(context, ref);
}
