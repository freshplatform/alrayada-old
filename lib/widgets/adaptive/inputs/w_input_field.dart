import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/platform_checker.dart';
import '/widgets/adaptive/inputs/input_options.dart';

class AdaptiveTextFormField extends StatelessWidget {
  const AdaptiveTextFormField({
    required this.labelText, super.key,
    this.textInputAction,
    this.obscureText = false,
    this.icon,
    this.materialOptions,
    this.cupertinoOptions,
    this.keyboardType,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.controller,
  });
  final String labelText;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? icon;
  final MaterialTextFieldOptions? materialOptions;
  final CupertinoTextFieldOptions? cupertinoOptions;
  final TextInputType? keyboardType;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return PlatformChecker.isAppleProduct()
        ? CupertinoTextFormFieldRow(
            keyboardType: keyboardType,
            obscureText: obscureText,
            autocorrect: autocorrect,
            enableSuggestions: enableSuggestions,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            onSaved: (value) {},
            placeholder: labelText,
            prefix: Padding(
              padding: const EdgeInsets.all(8),
              child: cupertinoOptions?.prefix ?? icon,
            ),
            validator: validator,
            controller: controller,
            decoration: cupertinoOptions?.decoration,
          )
        : TextFormField(
            keyboardType: keyboardType,
            obscureText: obscureText,
            autocorrect: autocorrect,
            enableSuggestions: enableSuggestions,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            validator: validator,
            controller: controller,
            decoration: (materialOptions != null)
                ? materialOptions?.inputDecoration!
                    .copyWith(labelText: labelText)
                : InputDecoration(
                    labelText: labelText,
                    icon: icon,
                  ),
          );
  }
}
