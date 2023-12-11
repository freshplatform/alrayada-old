import '/core/locales.dart';
import 'package:flutter/widgets.dart' show BuildContext;

abstract class GlobalValidators {
  static String? validateIsNotEmpty(String? value, BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final field = value?.trim() ?? '';
    if (field.isEmpty) {
      return translations.field_should_not_be_empty;
    }
    return null;
  }
}
