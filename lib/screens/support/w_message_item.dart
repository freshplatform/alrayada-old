import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme_data.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/settings/settings_cubit.dart';
import '../../data/chat/m_chat_message.dart';
import '../../widgets/others/w_bubble_background.dart';

@immutable
class MessageItem extends StatelessWidget {
  const MessageItem({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final settingsState = context.read<SettingsState>();
    // Don't worry, MessageItem is should be called in place where we already check
    // if the user is null and we already handle that cases
    final user = context.read<AuthCubit>().state.userCredential?.user;
    if (user == null) {
      throw 'The user is required be authenticated.';
    }

    final cupertinoTheme = CupertinoTheme.of(context);
    final materialTheme = Theme.of(context);
    final isMe = message.isMe(user.userId);
    final messageAlignment = isMe ? Alignment.topRight : Alignment.topLeft;

    if (settingsState.useClassicMsgBubble) {
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
