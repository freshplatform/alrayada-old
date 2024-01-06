import 'dart:io' show SocketException;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_alrayada/server/server.dart';
import 'package:web_socket_channel/io.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../utils/constants/routes.dart';
import '../../utils/extensions/build_context.dart';
import '../../widgets/errors/w_internet_error.dart';
import '/screens/support/w_support_messages.dart';
import '/widgets/errors/w_error.dart';
import '/widgets/errors/w_not_authenticated.dart';
import 'w_new_message.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  static const routeName = '/support';

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  IOWebSocketChannel? _channel;
  late Future<void> _connectFuture;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    try {
      final user = context.read<AuthCubit>().state.userCredential;
      if (user == null) return;
      if (_channel != null) {
        // close previous connections
        _channel!.sink.close();
      }
      _channel = IOWebSocketChannel.connect(
        RoutesConstants.appSupportRoutes.userChat,
        // BEcasue we are not using Dio
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

  Future<void> _refresh() async {
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
    final translations = context.loc;
    final user = context.read<AuthCubit>().state.userCredential;
    if (user == null) {
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
