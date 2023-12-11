import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/locales.dart';
import '/providers/p_user.dart';
import '/utils/validators/auth_validators.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ForgotPasswordDialog extends ConsumerStatefulWidget {
  const ForgotPasswordDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _emailError = '';
  var _isLoading = false;

  void setLoading(bool newValue) => setState(() {
        _isLoading = newValue;
      });

  Future<void> _submit() async {
    _emailError = '';
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }
    _formKey.currentState?.save();
    setLoading(true);
    final error =
        await ref.read(UserNotifier.provider.notifier).forgotPassword(_email);
    if (error == null) {
      Future.microtask(() => Navigator.of(context).pop(true));
      return;
    }
    final translations = await Future.microtask(
      () => AppLocalizations.of(context)!,
    );

    _emailError = error
        .replaceAll(
          'Email not found. Please check your email address and try again.',
          translations.auth_email_not_found,
        )
        .replaceAll(
          'Error while updating forgot password link, Please try again later or contact us.',
          translations.unknown_error,
        );
    _formKey.currentState?.validate();
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return PlatformAlertDialog(
      material: (context, platform) => MaterialAlertDialogData(
        icon: const Icon(Icons.lock_reset_outlined),
      ),
      title: Text(translations.reset_password),
      actions: [
        PlatformDialogAction(
          child: Text(translations.cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        PlatformDialogAction(
          onPressed: _isLoading ? null : () => _submit(),
          child: Text(translations.submit),
        )
      ],
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlatformTextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.none,
              autofillHints: const [AutofillHints.email],
              material: (context, platform) => MaterialTextFormFieldData(
                decoration: InputDecoration(
                  labelText: translations.email_address,
                  icon: const Icon(Icons.email),
                ),
              ),
              cupertino: (context, platform) => CupertinoTextFormFieldData(
                  prefix: const Icon(CupertinoIcons.mail)),
              minLines: 1,
              maxLines: 1,
              onFieldSubmitted: (value) => _submit(),
              hintText: translations.email_address,
              validator: (value) {
                if (_emailError.isNotEmpty) {
                  return _emailError;
                }
                return AuthValidators.validateEmail(value, context);
              },
              onSaved: (value) => _email = value!,
            ),
          ],
        ),
      ),
    );
  }
}
