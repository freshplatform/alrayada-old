import 'package:alrayada/providers/p_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/locales.dart';
import '/screens/notification/s_notification_list.dart';
import '../../account_data/s_account_data.dart';
import '../../settings/s_settings.dart';
import '../../support/s_support.dart';

class DashboardMaterialDrawer extends ConsumerWidget {
  const DashboardMaterialDrawer({Key? key, required this.translations})
      : super(key: key);

  final AppLocalizations translations;

  Widget _buildItem({
    required BuildContext context,
    required WidgetRef ref,
    required IconData leadingIcon,
    required String title,
    required VoidCallback onTap,
    bool authenticationRequired = false,
  }) =>
      Semantics(
        label: '$title ${translations.item}',
        child: ListTile(
          leading: Icon(
            leadingIcon,
            semanticLabel: title,
          ),
          title: Text(title),
          onTap: () {
            Navigator.of(context).pop();
            if (authenticationRequired) {
              final userContainer = ref.read(UserNotifier.provider);
              if (userContainer == null) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(translations.you_need_to_login_first),
                  ),
                );
                return;
              }
            }
            onTap();
          },
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      semanticLabel: 'Drawer',
      child: ListView(
        padding: EdgeInsets.zero, // Required
        children: [
          Consumer(
            builder: (context, provider, _) {
              final user = ref.watch(UserNotifier.provider);
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                currentAccountPicture: const FlutterLogo(),
                accountName: Text(
                  user != null
                      ? user.user.data.labName
                      : translations.guest_user,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: user != null
                    ? Text(user.user.data.labOwnerName)
                    : const SizedBox.shrink(),
              );
            },
          ),
          _buildItem(
            context: context,
            ref: ref,
            leadingIcon: Icons.message,
            title: translations.support,
            onTap: () =>
                Navigator.of(context).pushNamed(SupportScreen.routeName),
            authenticationRequired: true,
          ),
          _buildItem(
            context: context,
            ref: ref,
            leadingIcon: Icons.account_circle,
            title: translations.account,
            onTap: () =>
                Navigator.of(context).pushNamed(AccountDataScreen.routeName),
            authenticationRequired: true,
          ),
          _buildItem(
            context: context,
            ref: ref,
            leadingIcon: Icons.notifications,
            title: translations.notifications,
            onTap: () => Navigator.of(context)
                .pushNamed(NotificationListScreen.routeName),
            authenticationRequired: false,
          ),
          _buildItem(
            context: context,
            ref: ref,
            leadingIcon: Icons.settings,
            title: translations.settings,
            onTap: () =>
                Navigator.of(context).pushNamed(SettingsScreen.routeName),
            authenticationRequired: false,
          ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.logout),
          //   title: Text(translations.logout),
          //   onTap: () {},
          // )
        ],
      ),
    );
  }
}
