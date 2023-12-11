import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/locales.dart';
import '/providers/p_settings.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:web_socket_channel/io.dart';

class NewSupportChatMessage extends ConsumerStatefulWidget {
  const NewSupportChatMessage(
      {Key? key, required this.scrollController, required this.channel})
      : super(key: key);

  final ScrollController scrollController;
  final IOWebSocketChannel channel;

  @override
  ConsumerState<NewSupportChatMessage> createState() =>
      _NewSupportChatMessageState();
}

class _NewSupportChatMessageState extends ConsumerState<NewSupportChatMessage> {
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  ScrollController get scrollController => widget.scrollController;

  void _submit() {
    if (_messageController.text.isEmpty) return;
    final settingsData = ref.read(SettingsNotifier.settingsProvider);
    if (settingsData.unFocusAfterSendMsg) {
      FocusScope.of(context).unfocus();
    }
    final message = _messageController.text;
    _messageController.clear();
    if (scrollController.positions.isNotEmpty) {
      if (!settingsData.isAnimationsEnabled) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      } else {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
    widget.channel.sink.add(message);
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // PlatformIconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.attachment),
          // ),
          Expanded(
            child: PlatformTextField(
              controller: _messageController,
              hintText: translations.enter_your_message_here,
              keyboardType: TextInputType.multiline,
              // textInputAction: TextInputAction.newline,
              textInputAction: TextInputAction.send,
              minLines: 1,
              maxLines: 5,
              material: (context, platform) => MaterialTextFieldData(
                decoration: InputDecoration(
                  labelText: translations.message,
                  border: const OutlineInputBorder(),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => setState(() {}),
              onSubmitted: (value) => _submit(),
            ),
          ),
          PlatformIconButton(
            icon: Icon(
              _messageController.text.isEmpty
                  ? (isCupertino(context)
                      ? CupertinoIcons.paperplane
                      : Icons.send_outlined)
                  : (isCupertino(context)
                      ? CupertinoIcons.paperplane_fill
                      : Icons.send_rounded),
            ),
            onPressed: _messageController.text.isNotEmpty ? _submit : null,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
