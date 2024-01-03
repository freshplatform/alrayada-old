import 'package:flutter/material.dart' show InputDecoration;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/locales.dart';
import '/providers/p_user.dart';
import '/services/native/connectivity_checker/s_connectivity_checker.dart';

class DeleteAccount extends ConsumerStatefulWidget {
  const DeleteAccount({super.key});

  @override
  ConsumerState<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends ConsumerState<DeleteAccount> {
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
    final provider = ref.read(UserNotifier.provider.notifier);
    final hasConnection =
        await ConnectivityCheckerService.instance.hasConnection();
    if (!hasConnection) return;
    setLoading(true);
    final success = await provider.deleteAccount();
    if (success) {
      navigator.pop();
      navigator.pop();
      // Future.microtask(() {
      //   Navigator.of(context).pop();
      //   Navigator.of(context).pop();
      // });
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;

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
