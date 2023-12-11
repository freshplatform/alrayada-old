import 'package:alrayada_admin/providers/p_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/chat/m_chat_message.dart';

import '../../../chat/s_chat.dart';

class ChatRoomItem extends ConsumerWidget {
  const ChatRoomItem({super.key, required this.chatRoom, required this.index});
  final ChatRoom chatRoom;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatProvider = ref.read(SupportChatsNotififer.provider.notifier);
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ChatScreen.routeName, arguments: chatRoom.chatRoomId);
      },
      title: Text(chatRoom.userData.labName),
      subtitle: Text(chatRoom.userData.labOwnerName),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          chatProvider.deleteRoom(chatRoom.chatRoomId, index);
        },
      ),
    );
  }
}
