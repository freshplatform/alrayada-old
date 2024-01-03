import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class NewChatMessage extends StatefulWidget {
  const NewChatMessage(
      {required this.channel, required this.scrollController, super.key});

  final IOWebSocketChannel channel;
  final ScrollController scrollController;

  @override
  State<NewChatMessage> createState() => _NeChatwMessageState();
}

class _NeChatwMessageState extends State<NewChatMessage> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: 500,
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              // textInputAction: TextInputAction.newline,
              // keyboardType: TextInputType.multiline,
              // maxLines: null,
              onSubmitted: (value) => _send(),
              decoration: const InputDecoration(labelText: 'Write a message'),
            ),
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: _send,
        )
      ],
    );
  }

  void _send() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    widget.channel.sink.add(_messageController.text);
    if (widget.scrollController.positions.isNotEmpty) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
