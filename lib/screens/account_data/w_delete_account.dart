import 'package:flutter/material.dart' show InputDecoration;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../utils/extensions/build_context.dart';
import '/services/native/connectivity_checker/s_connectivity_checker.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  var _isLoading = false;
  late final TextEditingController _confirmationController;

  @override
  void initState() {
    super.initState();
    _confirmationController = TextEditingController();
  }

  void setLoading(bool newValue) => setState(() {
        _isLoading = newValue;
      });

  Future<void> _deleteAccount() async {
    final navigator = Navigator.of(context);
    final authBloc = context.read<AuthCubit>();
    final hasConnection =
        await ConnectivityCheckerService.instance.hasConnection();
    if (!hasConnection) return;
    setLoading(true);
    try {
      await authBloc.deleteAccount();
      navigator.pop();
      navigator.pop();
    } catch (e) {
      // TODO: Handle errors
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;

    return PlatformAlertDialog(
      title: Text(translations.confirm_delete_account),
      content: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(translations.auth_account_delete_confirmation),
            const SizedBox(height: 6),
            PlatformTextField(
              controller: _confirmationController,
              hintText: translations.delete,
              onChanged: (v) => setState(() {}),
              cupertino: (context, platform) => CupertinoTextFieldData(
                placeholder: translations.delete_account,
              ),
              material: (context, platform) => MaterialTextFieldData(
                  decoration: InputDecoration(
                labelText: translations.delete_account,
              )),
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
          onPressed: (_confirmationController.text == translations.delete &&
                  !_isLoading)
              ? _deleteAccount
              : null,
          child: Text(translations.delete),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }
}
