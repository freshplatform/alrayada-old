import 'package:alrayada/core/locales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    Key? key,
    this.onSaved,
    this.validator,
    required this.labelText,
    required this.materialIcon,
    required this.cupertinoIcon,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.nextFocus,
    this.focusNode,
  }) : super(key: key);

  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final String? labelText;
  final Widget materialIcon;
  final Widget cupertinoIcon;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? nextFocus;
  final FocusNode? focusNode;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  var _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return Semantics(
      label: translations.confirm_password,
      child: PlatformTextFormField(
        hintText: widget.labelText ?? translations.confirm_password,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        onEditingComplete: () {
          if (widget.nextFocus != null) {
            widget.nextFocus!.requestFocus();
            return;
          }
          FocusManager.instance.primaryFocus?.unfocus();
        },
        textCapitalization: TextCapitalization.none,
        obscureText: _obscureText,
        enableSuggestions: false,
        autocorrect: false,
        minLines: 1,
        maxLines: 1,
        onFieldSubmitted: widget.onFieldSubmitted,
        onSaved: widget.onSaved,
        controller: widget.controller,
        cupertino: (_, __) => CupertinoTextFormFieldData(
          placeholder: widget.labelText ?? translations.confirm_password,
          prefix: Row(
            children: [
              widget.cupertinoIcon,
              PlatformIconButton(
                onPressed: () => setState(
                  () => _obscureText = !_obscureText,
                ),
                icon: Icon(_obscureText
                    ? CupertinoIcons.eye_slash
                    : Icons.remove_red_eye),
              )
            ],
          ),
        ),
        material: (_, __) => MaterialTextFormFieldData(
          decoration: InputDecoration(
            labelText: widget.labelText ?? translations.confirm_password,
            prefixIcon: widget.materialIcon,
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                _obscureText = !_obscureText;
              }),
              icon: Icon(_obscureText
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye_rounded),
            ),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
