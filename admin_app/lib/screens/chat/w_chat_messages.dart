import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_alrayada/data/chat/m_chat_message.dart';
import 'package:web_socket_channel/io.dart';

import 'w_message_item.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({
    required this.scrollController,
    required this.channel,
    super.key,
  });

  final ScrollController scrollController;
  final IOWebSocketChannel channel;

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  final messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.channel.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        try {
          final json = jsonDecode(snapshot.data as String);
          if (json is Map<String, dynamic>) {
            final message = ChatMessage.fromJson(json);
            messages.add(message);
          } else if (json is List<dynamic>) {
            messages.addAll(json.map((e) => ChatMessage.fromJson(e)));
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
          ));
        }
        return ListView.builder(
          controller: widget.scrollController,
          itemCount: messages.length,
          reverse: true,
          itemBuilder: (context, index) {
            final messageItem = messages[index];
            return MessageItem(
              key: ValueKey('${messageItem.id}$index'),
              message: messageItem,
            );
          },
        );
      },
    );
  }
}
