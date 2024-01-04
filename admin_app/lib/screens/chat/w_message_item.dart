import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/chat/m_chat_message.dart';

import '../../providers/p_user.dart';

@immutable
class MessageItem extends ConsumerWidget {
  const MessageItem({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(UserNotifier.provider)!.user;
    final isMe = message.isMe(user.userId);
    final messageAlignment = isMe ? Alignment.topRight : Alignment.topLeft;

    return Align(
      alignment: messageAlignment,
      child: SizedBox(
        width: 140,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          // padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          // width: 140,
          // decoration: BoxDecoration(
          //   color: Theme.of(context).colorScheme.secondary,
          //   borderRadius: BorderRadius.only(
          //     topLeft: const Radius.circular(12),
          //     topRight: const Radius.circular(12),
          //     bottomLeft:
          //         !isMe ? const Radius.circular(0) : const Radius.circular(12),
          //     bottomRight:
          //         isMe ? const Radius.circular(0) : const Radius.circular(12),
          //   ),
          // ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  !isMe ? user.data.labOwnerName : 'Admin',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
