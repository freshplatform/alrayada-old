import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/chat/m_chat_message.dart';

import '../../../../providers/p_chat.dart';
import '../../../chat/s_chat.dart';

class ChatRoomItem extends ConsumerWidget {
  const ChatRoomItem({required this.chatRoom, required this.index, super.key});
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
