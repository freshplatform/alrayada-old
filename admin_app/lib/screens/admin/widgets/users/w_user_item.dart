import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

import '../../../../providers/p_admin_user.dart';
import '../../../chat/s_chat.dart';
import 'w_send_notification.dart';

class UserItem extends ConsumerWidget {
  const UserItem({
    required this.unWatchedUser,
    required this.index,
    required this.onDeleteItem,
    super.key,
  });

  // final Function(int index, User user) onDelete;

  final User unWatchedUser;
  final int index;
  final Function(int index) onDeleteItem;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(UserItemNotififer.provider(unWatchedUser));
    final userItemProvider =
        ref.read(UserItemNotififer.provider(unWatchedUser).notifier);

    return ListTile(
      onTap: () => showDialog(
        context: context,
        builder: (context) => UserItemDataDialog(user.data),
      ),
      title: Text(user.email),
      subtitle: Text('#${index + 1} - ${user.data.labName}'),
      leading: Icon(
        user.accountActivated ? Icons.verified_user : Icons.rate_review,
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            child: Text(user.accountActivated ? 'Deactivate' : 'Activate'),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              if (user.accountActivated) {
                final error = await userItemProvider.deactivateAccount();
                if (error != null) {
                  messenger.clearSnackBars();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(error),
                    ),
                  );
                }
                return;
              }
              final error = await userItemProvider.activateAccount();

              if (error != null) {
                messenger.clearSnackBars();
                messenger.showSnackBar(SnackBar(
                  content: Text(error),
                ));
              }
            },
          ),
          PopupMenuItem<String>(
            child: const Text('Delete'),
            onTap: () async {
              final error = await ref
                  .read(AdminUsersNotifier.provider.notifier)
                  .deleteUserAccount(
                    context: context,
                    index: index,
                    email: user.email,
                  );
              if (error == null) {
                onDeleteItem(index);
                Future.microtask(() {
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.clearSnackBars();
                  messenger.showSnackBar(const SnackBar(
                    content: Text('User has been deleted!'),
                  ));
                });
                return;
              }
              Future.microtask(() {
                final messenger = ScaffoldMessenger.of(context);
                messenger.clearSnackBars();
                messenger.showSnackBar(SnackBar(content: Text(error)));
              });
            },
          ),
          PopupMenuItem<String>(
            child: const Text('Send notification'),
            onTap: () async {
              await Future.delayed(Duration.zero);
              Future.microtask(
                () => showDialog(
                  context: context,
                  builder: (context) => SendNotificationDialog(user),
                ),
              );
            },
          ),
          PopupMenuItem<String>(
            child: const Text('Chat'),
            onTap: () async {
              await Future.delayed(Duration.zero);
              Future.microtask(() => Navigator.of(context).pushNamed(
                    ChatScreen.routeName,
                    arguments: user.userId,
                  ));
            },
          ),
        ],
      ),
    );
  }
}

class UserItemDataDialog extends StatelessWidget {
  const UserItemDataDialog(this.userData, {super.key});

  final UserData userData;

  @override
  Widget build(BuildContext context) {
    // final userData = user.data;
    return AlertDialog(
      title: const Text('User data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 20),
              children: <TextSpan>[
                const TextSpan(
                  text: 'Owner name: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${userData.labOwnerName}\n',
                ),
                const TextSpan(
                  text: 'Owner phone: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${userData.labOwnerPhoneNumber}\n',
                ),
                const TextSpan(
                  text: 'Lab phone: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${userData.labPhoneNumber}\n',
                ),
                const TextSpan(
                  text: 'Lab City: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: userData.city.name,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
