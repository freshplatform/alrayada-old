import 'package:alrayada_admin/providers/p_chat.dart';
import 'package:alrayada_admin/screens/admin/widgets/chat_rooms/w_chat_room_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomsListPage extends ConsumerStatefulWidget {
  const ChatRoomsListPage({super.key});

  @override
  ConsumerState<ChatRoomsListPage> createState() => _ChatRoomsListPageState();
}

class _ChatRoomsListPageState extends ConsumerState<ChatRoomsListPage> {
  Widget get content => Consumer(
        builder: (context, ref, _) {
          final chatRooms = ref.watch(SupportChatsNotififer.provider);
          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              return ChatRoomItem(chatRoom: chatRoom, index: index);
            },
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final chatProvider = ref.read(SupportChatsNotififer.provider.notifier);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chat rooms'),
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => setState(
            () => chatProvider.reset(),
          ),
        ),
      ),
      body: chatProvider.isInitLoading
          ? FutureBuilder(
              future: chatProvider.loadRooms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                chatProvider.isInitLoading = false;
                return content;
              },
            )
          : content,
    );
  }
}
