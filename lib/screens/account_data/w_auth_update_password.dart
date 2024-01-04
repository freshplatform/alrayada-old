import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/build_context.dart';
import '/providers/p_user.dart';
import '/utils/validators/auth_validators.dart';
import '/widgets/inputs/password/w_password.dart';

class AuthUpdatePasswordDialog extends ConsumerStatefulWidget {
  const AuthUpdatePasswordDialog({super.key});

  @override
  ConsumerState<AuthUpdatePasswordDialog> createState() =>
      _AuthUpdatePasswordDialogState();
}

class _AuthUpdatePasswordDialogState
    extends ConsumerState<AuthUpdatePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  var _passwordError = '';
  var _currentPassword = '';
  var _newPassword = '';
  var _isLoading = false;

  void setLoading(bool newValue) => setState(() {
        _isLoading = newValue;
      });

  Future<void> _submit() async {
    _passwordError = '';
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }
    _formKey.currentState!.save();
    setLoading(true);
    final error =
        await ref.read(UserNotifier.provider.notifier).updateUserPassword(
              currentPassword: _currentPassword,
              newPassword: _newPassword,
            );
    if (error == null) {
      Future.microtask(() => Navigator.of(context).pop(true));
      return;
    }

    _passwordError = error;
    _formKey.currentState?.validate();
    setLoading(false);
  }

  final _newPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return PlatformAlertDialog(
      title: Text(translations.update_password),
      material: (context, platform) => MaterialAlertDialogData(
        icon: const Icon(
          Icons.account_box,
          size: 50,
        ),
      ),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PasswordTextFormField(
              labelText: translations.current_password,
              textInputAction: TextInputAction.next,
              onSaved: (value) => _currentPassword = value!,
              cupertinoIcon: const Icon(CupertinoIcons.padlock),
              materialIcon: const Icon(Icons.lock_outlined),
              nextFocus: _newPasswordFocusNode,
              validator: (value) {
                if (_passwordError.isNotEmpty) return _passwordError;
                return AuthValidators.validatePassword(value, context);
              },
            ),
            PasswordTextFormField(
              labelText: translations.new_password,
              onSaved: (value) => _newPassword = value!,
              cupertinoIcon: const Icon(CupertinoIcons.lock_fill),
              materialIcon: const Icon(Icons.lock),
              focusNode: _newPasswordFocusNode,
              validator: (value) {
                if (_passwordError.isNotEmpty) return _passwordError;
                return AuthValidators.validatePassword(value, context);
              },
            ),
          ],
        ),
      ),
      actions: [
        PlatformDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(translations.cancel),
        ),
        PlatformDialogAction(
          onPressed: _isLoading ? null : _submit,
          child: Text(translations.update),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _newPasswordFocusNode.dispose();
    super.dispose();
  }
}
