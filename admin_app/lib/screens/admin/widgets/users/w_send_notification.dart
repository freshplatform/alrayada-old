import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

import '../../../../providers/p_admin_user.dart';
import '../../../../utils/validators/global.dart';

class SendNotificationDialog extends ConsumerStatefulWidget {
  const SendNotificationDialog(this.user, {super.key});
  final User user;

  @override
  ConsumerState<SendNotificationDialog> createState() =>
      _SendNotificationDialogState();
}

class _SendNotificationDialogState
    extends ConsumerState<SendNotificationDialog> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var _title = '';
  var _body = '';
  var _error = '';

  void setLoading(bool value) => setState(() {
        _isLoading = value;
      });

  Future<void> _submit() async {
    _error = '';
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }
    _formKey.currentState!.save();
    setLoading(true);
    final responseError = await ref
        .read(UserItemNotififer.provider(widget.user).notifier)
        .sendNotification(title: _title, body: _body);
    if (responseError == null) {
      Future.microtask(() {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Notification has been successfully sent'),
        ));
      });
      return;
    }
    setLoading(false);
    _error = responseError;
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send notification'),
      icon: const Icon(Icons.notification_add),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (_error.isNotEmpty) {
                  return _error;
                }
                return GlobalValidators.validateIsNotEmpty(value);
              },
              onSaved: (value) => _title = value ?? '',
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Body',
              ),
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (value) => _submit(),
              validator: (value) {
                if (_error.isNotEmpty) {
                  return _error;
                }
                return GlobalValidators.validateIsNotEmpty(value);
              },
              onSaved: (value) => _body = value ?? '',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop()),
        TextButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : const Text('Send'),
        ),
      ],
    );
  }
}
