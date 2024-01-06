import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../utils/extensions/build_context.dart';
import '/screens/auth/w_auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    final translations = context.loc;
    return Semantics(
      label: translations.auth_screen,
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(translations.authentication),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(right: 20),
                width: double.infinity,
                child: const FlutterLogo(
                  size: 150,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Container(
                      margin: EdgeInsets.zero,
                      color: isCupertino(context)
                          ? cupertinoTheme.barBackgroundColor
                          : materialTheme.cardColor,
                      child: const SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: AuthForm(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
