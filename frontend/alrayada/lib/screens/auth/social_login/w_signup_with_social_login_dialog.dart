import 'package:alrayada/providers/p_user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

import '/core/locales.dart';
import '/data/social_authentication/social_authentication.dart';
import '/screens/auth/w_auth_form_inputs.dart';

class SignUpWithSocialLoginDialog extends ConsumerStatefulWidget {
  const SignUpWithSocialLoginDialog({
    Key? key,
    this.initialLabOwnerName = '',
    required this.provider,
    required this.socialAuthentication,
  }) : super(key: key);

  final String initialLabOwnerName;
  final String provider;
  final SocialAuthentication socialAuthentication;

  @override
  ConsumerState<SignUpWithSocialLoginDialog> createState() =>
      _SignUpWithSocialLoginDialogState();
}

class _SignUpWithSocialLoginDialogState
    extends ConsumerState<SignUpWithSocialLoginDialog> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var _userData = const UserData(
    labName: '',
    labOwnerName: '',
    labOwnerPhoneNumber: '',
    labPhoneNumber: '',
  );

  void setLoading(bool newValue) => setState(() => _isLoading = newValue);

  Future<void> _signUp() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    _formKey.currentState!.save();
    final userProvider = ref.read(UserNotifier.provider.notifier);
    setLoading(true);
    widget.socialAuthentication.signUpUserData = _userData;
    final error = await userProvider.authenticateWithSocialLogin(
      widget.socialAuthentication,
      widget.provider,
    );
    setLoading(false);
    if (error == null) {
      Future.microtask(() {
        Navigator.of(context).pop(); // close the dialog
        Navigator.of(context).pop(); // get back to dashboard
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return LayoutBuilder(builder: (context, constraints) {
      final shared = PlatformAlertDialog(
        title: Text(translations.create_new_account),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: userDataTextFields(
                context: context,
                onLabOwnerPhoneNumberSaved: (value) => _userData =
                    _userData.copyWith(labOwnerPhoneNumber: value ?? ''),
                onLabPhoneNumberSaved: (value) =>
                    _userData = _userData.copyWith(labPhoneNumber: value ?? ''),
                onLabNameSaved: (value) =>
                    _userData = _userData.copyWith(labName: value ?? ''),
                onLabOwnerNameSaved: (value) =>
                    _userData = _userData.copyWith(labOwnerName: value ?? ''),
                onCitySaved: (value) => _userData =
                    _userData.copyWith(city: value ?? IraqGovernorate.baghdad),
                labOwnerName: widget.initialLabOwnerName,
              ),
            ),
          ),
        ),
        actions: [
          PlatformDialogAction(
            child: Text(translations.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          PlatformDialogAction(
            onPressed: _isLoading ? null : _signUp,
            child: Text(translations.sign_up),
          )
        ],
      );

      if (constraints.maxWidth <= 345) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: shared,
        );
      }
      return shared;
    });
  }
}
