import 'dart:io' show SocketException;

import 'package:alrayada/utils/constants/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/locales.dart';
import '/providers/p_user.dart';
import '/screens/support/w_support_messages.dart';
import '/widgets/errors/w_error.dart';
import '/widgets/errors/w_not_authenticated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_alrayada/server/server.dart';
import 'package:web_socket_channel/io.dart';

import '../../widgets/errors/w_internet_error.dart';
import 'w_new_message.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  static const routeName = '/support';

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  IOWebSocketChannel? _channel;
  late Future<void> _connectFuture;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    try {
      final user = ref.read(UserNotifier.provider);
      if (user == null) return;
      if (_channel != null) {
        // close previous connections
        _channel!.sink.close();
      }
      _channel = IOWebSocketChannel.connect(
        RoutesConstants.appSupportRoutes.userChat,
        headers: {
          'Authorization': 'Bearer ${user.token}',
          'Api': ServerConfigurations.serverApiKey,
        },
      );
      _connectFuture = _channel!.ready;
      await _connectFuture;
      // _channel!.stream.handleError((error) {});
    } on SocketException {
      return Future.value();
    }
  }

  void _refresh() async {
    await _connect();
    setState(() {});
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final userContainer = ref.read(UserNotifier.provider);
    if (userContainer == null) {
      return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(translations.not_authenticated),
        ),
        body: const SafeArea(
          child: NotAuthenticatedError(),
        ),
      );
    }
    final scrollController = ScrollController();
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(translations.support),
      ),
      body: FutureBuilder(
        future: _connectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            if (snapshot.error is SocketException) {
              return InternetErrorWithTryAgain(
                onTryAgain: _refresh,
              );
            }
            return ErrorWithTryAgain(
              onTryAgain: _refresh,
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SupportMessagesList(
                  scrollController: scrollController,
                  channel: _channel!,
                  onTryAgain: _refresh,
                ),
              ),
              NewSupportChatMessage(
                scrollController: scrollController,
                channel: _channel!,
              ),
            ],
          );
        },
      ),
    );
  }
}
