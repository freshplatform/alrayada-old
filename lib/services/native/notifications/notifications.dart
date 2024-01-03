import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;
import 'package:shared_alrayada/data/user/m_user.dart';

abstract class Notifications {
  Future<void> registerNotificationsHandlers(
      BuildContext context, WidgetRef ref);
  Future<UserDeviceNotificationsToken> getUserDeviceToken();
}
