import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

import '../../extensions/build_context.dart';
import '../../providers/p_user.dart';
import '../../widgets/adaptive/messenger.dart';
import '../../widgets/adaptive/w_icon.dart';
import '/screens/account_data/w_delete_account.dart';
import '/screens/auth/w_auth_form_inputs.dart';
import '/widgets/buttons/w_outlined_button.dart';
import 'w_auth_update_password.dart';

class AccountDataScreen extends ConsumerStatefulWidget {
  const AccountDataScreen({super.key});

  static const routeName = '/account';

  @override
  ConsumerState<AccountDataScreen> createState() => _AccountDataScreenState();
}

class _AccountDataScreenState extends ConsumerState<AccountDataScreen> {
  var _updateFormUserData = const UserData(
      labOwnerPhoneNumber: '',
      labPhoneNumber: '',
      labName: '',
      labOwnerName: '');
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  void setLoading(bool newValue) => setState(() => _isLoading = newValue);

  Future<void> _updateUserData() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    _formKey.currentState?.save();
    final translations = context.loc;

    setLoading(true);
    final error = await ref
        .read(UserNotifier.provider.notifier)
        .updateUserData(_updateFormUserData);
    setLoading(false);
    final message = error ?? translations.data_has_been_successfully_updated;
    Future.microtask(() {
      AdaptiveMessenger.showPlatformMessage(
        context: context,
        message: message,
        title: error == null ? translations.success : translations.error,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(translations.account_data),
        trailingActions: [
          PlatformIconButton(
            icon: const PlatformAdaptiveIcon(
              iconData: Icons.lock,
              cupertinoIconData: CupertinoIcons.lock_fill,
            ),
            onPressed: () => showPlatformDialog<void>(
              context: context,
              builder: (context) => const AuthUpdatePasswordDialog(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            final user = ref.watch(UserNotifier.provider)?.user;
            if (user == null) {
              return Center(
                child: Text(translations.not_authenticated),
              );
            }
            final currentUserData = user.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  const FlutterLogo(
                    size: 200,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  PlatformListTile(
                    title: Text(translations.email_address),
                    subtitle: Text(user.email),
                    trailing: const PlatformAdaptiveIcon(
                      iconData: Icons.email,
                      cupertinoIconData: CupertinoIcons.mail_solid,
                    ),
                    onTap: () {},
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formKey,
                    child: Column(
                      children: [
                        ...userDataTextFields(
                          context: context,
                          onLabOwnerPhoneNumberSaved: (value) =>
                              _updateFormUserData = _updateFormUserData
                                  .copyWith(labOwnerPhoneNumber: value ?? ''),
                          onLabPhoneNumberSaved: (value) =>
                              _updateFormUserData = _updateFormUserData
                                  .copyWith(labPhoneNumber: value ?? ''),
                          onLabNameSaved: (value) => _updateFormUserData =
                              _updateFormUserData.copyWith(
                                  labName: value ?? ''),
                          onLabOwnerNameSaved: (value) => _updateFormUserData =
                              _updateFormUserData.copyWith(
                                  labOwnerName: value ?? ''),
                          onCitySaved: (value) => _updateFormUserData =
                              _updateFormUserData.copyWith(
                                  city: value ?? IraqGovernorate.baghdad),
                          labOwnerPhoneNumber:
                              currentUserData.labOwnerPhoneNumber,
                          labPhoneNumber: currentUserData.labPhoneNumber,
                          labName: currentUserData.labName,
                          labOwnerName: currentUserData.labOwnerName,
                          city: currentUserData.city,
                        ),
                        const SizedBox(height: 12),
                        if (!_isLoading)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: PlatformElevatedButton(
                                onPressed: _updateUserData,
                                child: Text(translations.update),
                              ),
                            ),
                          )
                        else
                          const CircularProgressIndicator.adaptive(),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: AdaptiveOutlinedButton(
                              child: Text(translations.delete_account),
                              onPressed: () => showPlatformDialog(
                                context: context,
                                builder: (context) => const DeleteAccount(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
