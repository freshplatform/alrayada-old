import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/locales.dart';
import '../../utils/constants/constants.dart';
import '/screens/auth/w_auth_form_inputs.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLogin = true;
  final _appChannel = const MethodChannel('${Constants.packageName}/app');

  @override
  void initState() {
    super.initState();
    if (!kDebugMode) {
      _secureScreen(true);
    }
  }

  void _secureScreen(bool private) =>
      _appChannel.invokeMethod('setWindowPrivate', private);

  @override
  void dispose() {
    super.dispose();
    _secureScreen(false);
  }

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    final translations = AppLocalizations.of(context)!;
    return Column(
      children: [
        const SizedBox(height: 14),
        Semantics(
          label: _isLogin
              ? translations.welcome_again
              : translations.register_account,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              _isLogin
                  ? translations.welcome_again
                  : translations.register_account,
              textAlign: TextAlign.center,
              style: (isCupertino(context)
                      ? cupertinoTheme.textTheme.navLargeTitleTextStyle
                      : materialTheme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.values.first))
                  ?.copyWith(fontSize: 30),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Semantics(
          label: translations.enter_the_account_credentials_to_continue,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              translations.enter_the_account_credentials_to_continue,
              textAlign: TextAlign.center,
              style: (isCupertino(context)
                      ? cupertinoTheme.textTheme.navTitleTextStyle
                          .copyWith(color: Colors.grey)
                      : materialTheme.textTheme.bodySmall)
                  ?.copyWith(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),
        AuthFormInputs(
          onIsLoginChange: (isLogin) => setState(() {
            _isLogin = isLogin;
          }),
        ),
      ],
    );
  }
}
