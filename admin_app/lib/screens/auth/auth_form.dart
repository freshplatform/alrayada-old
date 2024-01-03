import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/shared_alrayada.dart';

import '../../providers/p_user.dart';
import '../../utils/validators/auth.dart';

class AuthForm extends ConsumerStatefulWidget {
  const AuthForm({super.key});

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _error = '';
  var _isLoading = false;

  void setLoading(bool value) => setState(() {
        _isLoading = value;
      });

  Future<void> _signIn() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    _formKey.currentState!.save();
    _error = '';

    try {
      setLoading(true);
      await ref
          .read(UserNotifier.provider.notifier)
          .authenticateWithEmailAndPassword(
            true,
            AuthRequest(
              email: _email,
              password: _password,
              deviceToken: const UserDeviceNotificationsToken(),
            ),
          );
      if (ref.read(UserNotifier.provider)!.user.role != UserRole.admin) {
        setState(() {
          _error = 'You are not an admin';
        });
        ref.read(UserNotifier.provider.notifier).logout();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: AuthValidators.validateEmail,
              onSaved: (value) => _email = value ?? '',
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 250,
            child: TextFormField(
              // textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: AuthValidators.validatePassword,
              onSaved: (value) => _password = value ?? '',
              onFieldSubmitted: (_) => _signIn(),
            ),
          ),
          const SizedBox(height: 12),
          _isLoading
              ? const CircularProgressIndicator.adaptive()
              : FilledButton(
                  onPressed: _signIn,
                  child: const Text('Sign in'),
                ),
          const SizedBox(height: 4),
          if (_error.isNotEmpty) Text(_error),
        ],
      ),
    );
  }
}
