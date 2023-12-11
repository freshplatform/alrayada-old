import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/chat/m_chat_message.dart';

import '/providers/p_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme_data.dart';
import '../../providers/p_user.dart';
import '../../widgets/others/w_bubble_background.dart';

@immutable
class MessageItem extends ConsumerWidget {
  const MessageItem({Key? key, required this.message}) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsProvider = ref.read(SettingsNotifier.settingsProvider);
    // Don't worry, MessageItem is should be called in place where we already check
    // if the user is null and we already handle that cases
    final user = ref.read(UserNotifier.provider)!.user;
    final cupertinoTheme = CupertinoTheme.of(context);
    final materialTheme = Theme.of(context);
    final isMe = message.isMe(user.userId);
    final messageAlignment = isMe ? Alignment.topRight : Alignment.topLeft;

    if (settingsProvider.useClassicMsgBubble) {
      return Align(
        alignment: messageAlignment,
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          width: 140,
          decoration: BoxDecoration(
            color: isCupertino(context)
                ? cupertinoTheme.primaryColor
                : materialTheme.primaryColorLight,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                isMe ? user.data.labOwnerName : 'Admin',
                style: MyAppTheme.getNormalTextStyle(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message.text,
                style: MyAppTheme.getNormalTextStyle(context),
              ),
            ],
          ),
        ),
      );
    }
    return FractionallySizedBox(
      alignment: messageAlignment,
      widthFactor: 0.8,
      child: Align(
        alignment: messageAlignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
            child: BubbleBackground(
              colors: [
                if (!isMe) ...const [
                  Color(0xFF6C7689),
                  Color(0xFF3A364B),
                ] else ...const [
                  Color(0xFF19B7FF),
                  Color(0xFF491CCB),
                ],
              ],
              child: DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(message.text),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
