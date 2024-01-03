abstract class GlobalValidators {
  static String? validateIsNotEmpty(String? value) {
    final field = value?.trim() ?? '';
    if (field.isEmpty) {
      return 'Field should not be empty';
    }
    return null;
  }
}
