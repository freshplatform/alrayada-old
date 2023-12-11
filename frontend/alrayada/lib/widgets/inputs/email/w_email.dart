import 'package:alrayada/core/locales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({
    super.key,
    this.onSaved,
    this.validator,
    this.labelText,
    this.controller,
    required this.textInputAction,
    this.onFieldSubmitted,
    this.nextFocus,
    this.focusNode,
  });

  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? nextFocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return Semantics(
      label: translations.email_address,
      child: PlatformTextFormField(
        textInputAction: textInputAction,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        enableSuggestions: true,
        focusNode: focusNode,
        onEditingComplete: () {
          if (nextFocus != null) {
            nextFocus!.requestFocus();
            return;
          }
          FocusManager.instance.primaryFocus?.unfocus();
        },
        autofillHints: const [AutofillHints.email],
        textCapitalization: TextCapitalization.none,
        hintText: translations.email_address,
        cupertino: (_, __) => CupertinoTextFormFieldData(
          prefix: const Icon(CupertinoIcons.mail),
          placeholder: labelText ?? translations.email_address,
        ),
        material: (_, __) => MaterialTextFormFieldData(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.mail),
            labelText: labelText ?? translations.email_address,
          ),
        ),
        minLines: 1,
        maxLines: 1,
        onSaved: onSaved,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
      ),
    );
  }
}
