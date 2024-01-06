import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../../data/chat/m_chat_message.dart';
import '/widgets/errors/w_error.dart';
import 'w_message_item.dart';

class SupportMessagesList extends StatefulWidget {
  const SupportMessagesList(
      {required this.scrollController,
      required this.channel,
      required this.onTryAgain,
      super.key});

  final ScrollController scrollController;
  final IOWebSocketChannel channel;

  final VoidCallback onTryAgain;

  @override
  State<SupportMessagesList> createState() => _SupportMessagesListState();
}

class _SupportMessagesListState extends State<SupportMessagesList> {
  final _messages = <ChatMessage>[];
  late final Stream<dynamic> _stream;

  @override
  void initState() {
    super.initState();
    _stream = widget.channel.stream.asBroadcastStream();
    _messages.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return ErrorWithTryAgain(onTryAgain: widget.onTryAgain);
        }
        try {
          final json = jsonDecode(snapshot.data as String);
          if (json is Map<String, dynamic>) {
            final message = ChatMessage.fromJson(json);
            _messages.add(message);
          } else if (json is List<dynamic>) {
            _messages.addAll(json.map((e) => ChatMessage.fromJson(e)));
          }
        } catch (e) {
          // TODO("Maybe handle errors")
        }
        return ListView.builder(
          controller: widget.scrollController,
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final messageItem = _messages[index];
            return MessageItem(
              key: ValueKey('${messageItem.id}$index'),
              message: messageItem,
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.channel.sink.close();
  }
}
