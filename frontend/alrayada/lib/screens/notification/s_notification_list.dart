import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart'
    show CircularProgressIndicator, FloatingActionButton, Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '/core/locales.dart';
import '/providers/p_notification.dart';
import '/widgets/adaptive/messenger.dart';
import '/widgets/adaptive/w_icon.dart';
import '/widgets/no_data/w_no_data.dart';
import '../../data/my_app_notification/m_my_app_notification.dart';

class NotificationListScreen extends ConsumerStatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  static const routeName = '/notificationList';

  @override
  ConsumerState<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState
    extends ConsumerState<NotificationListScreen> {
  final _animatedListKey = GlobalKey<AnimatedListState>();
  late Future<void> _loadNotificationsFuture;

  @override
  void initState() {
    super.initState();
    _loadNotificationsFuture = ref
        .read(NotificationNotififer.notificationsProvider.notifier)
        .loadAllNotifications();
  }

  Widget _buildItem(MyAppNotification notification, int index,
          Animation<double> animation) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: PlatformListTile(
          onTap: () => AdaptiveMessenger.showPlatformMessage(
            context: context,
            message: notification.body,
            title: notification.title,
            useSnackBarInMaterial: false,
          ),
          title: Text(notification.title),
          subtitle: Text(
            DateFormat.yMMMMEEEEd().format(notification.createdAt),
          ),
          trailing: PlatformIconButton(
            icon: const PlatformAdaptiveIcon(
              iconData: Icons.delete,
              cupertinoIconData: CupertinoIcons.delete,
            ),
            onPressed: () async {
              ref
                  .read(NotificationNotififer.notificationsProvider.notifier)
                  .removeNotificationByMessageId(notification.messageId);
              _animatedListKey.currentState?.removeItem(
                  index,
                  (context, animation) =>
                      _buildItem(notification, index, animation));
            },
          ),
          leading: SizedBox(
            width: 50,
            child: notification.imageUrl.isNotEmpty
                ? CachedNetworkImage(imageUrl: notification.imageUrl)
                : const Icon(Icons.image_not_supported),
          ),
        ),
      );

  Future<void> _deleteAll() async => await ref
      .read(NotificationNotififer.notificationsProvider.notifier)
      .removeAllNotifications();

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(translations.notifications),
        trailingActions: [
          PlatformIconButton(
            material: (context, platform) => MaterialIconButtonData(
              tooltip: translations.clear,
            ),
            onPressed: _deleteAll,
            icon: const PlatformAdaptiveIcon(
              iconData: Icons.clear,
              cupertinoIconData: CupertinoIcons.clear,
            ),
          )
        ],
      ),
      material: (context, platform) => MaterialScaffoldData(
        floatingActionButton: FloatingActionButton(
          tooltip: translations.delete,
          onPressed: _deleteAll,
          child: const Icon(Icons.delete),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _loadNotificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            return Consumer(builder: (context, ref, _) {
              final notifications =
                  ref.watch(NotificationNotififer.notificationsProvider);
              final notificationsProvider = ref
                  .read(NotificationNotififer.notificationsProvider.notifier);
              if (notifications.isEmpty) {
                return const NoDataWithoutTryAgain();
              }
              switch (notificationsProvider.lastAction) {
                case NotificationLastAction.addOne:
                  _animatedListKey.currentState
                      ?.insertItem(notifications.indexOf(notifications.last));
                  break;
                case NotificationLastAction.removeOne:
                  break;
                case NotificationLastAction.loadAll:
                  break;
                case NotificationLastAction.removeAll:
                  break;
                case NotificationLastAction.none:
                  break;
              }
              return AnimatedList(
                key: _animatedListKey,
                initialItemCount: notifications.length,
                itemBuilder: (context, index, animation) {
                  final notification = notifications[index];
                  return _buildItem(notification, index, animation);
                },
              );
            });
          },
        ),
      ),
    );
  }
}
