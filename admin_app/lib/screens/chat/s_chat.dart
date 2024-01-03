import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/server/server.dart';
import 'package:shared_alrayada/utils/constants/routes.dart';
import 'package:web_socket_channel/io.dart';

import '../../providers/p_user.dart';
import 'w_chat_messages.dart';
import 'w_new_message.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  static const routeName = '/chatDetails';

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final IOWebSocketChannel _channel;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  var _firstTime = true;
  @override
  void didChangeDependencies() {
    if (_firstTime) {
      final chatRoomId = ModalRoute.of(context)!.settings.arguments as String;
      _channel = IOWebSocketChannel.connect(
        RoutesConstants.appSupportRoutes.adminRoutes.chatWithUser(chatRoomId),
        headers: {
          'Authorization': 'Bearer ${ref.read(UserNotifier.provider)!.token}',
          'Api': ServerConfigurations.serverApiKey,
        },
      );
      _firstTime = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          NewChatMessage(
            channel: _channel,
            scrollController: _scrollController,
          )
        ],
      ),
      body: ChatMessagesList(
        channel: _channel,
        scrollController: _scrollController,
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
