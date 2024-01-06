import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../data/user/models/m_user.dart';
import '../../../utils/extensions/build_context.dart';
import '/data/social_authentication/social_authentication.dart';
import '/screens/auth/w_auth_form_inputs.dart';

class SignUpWithSocialLoginDialog extends StatefulWidget {
  const SignUpWithSocialLoginDialog({
    required this.provider,
    required this.socialAuthentication,
    super.key,
    this.initialLabOwnerName = '',
  });

  final String initialLabOwnerName;
  final String provider;
  final SocialAuthentication socialAuthentication;

  @override
  State<SignUpWithSocialLoginDialog> createState() =>
      _SignUpWithSocialLoginDialogState();
}

class _SignUpWithSocialLoginDialogState
    extends State<SignUpWithSocialLoginDialog> {
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
    final navigator = Navigator.of(context);
    if (!valid) return;
    _formKey.currentState?.save();

    final authBloc = context.read<AuthCubit>();

    try {
      setLoading(true);
      await authBloc.authenticateWithSocialLogin(
        widget.socialAuthentication.copyWith(signUpUserData: _userData),
      );
      navigator.pop(); // close the dialog
      navigator.pop(); // get back to dashboard
    } catch (e) {
      // TODO: Handle errors
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
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
