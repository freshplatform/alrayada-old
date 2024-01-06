import 'package:flutter/cupertino.dart';
import 'package:shared_alrayada/utils/constants/patterns.dart';

import '../extensions/build_context.dart';

abstract class AuthValidators {
  // TODO('Improve the auth validators')
  static String? validateEmail(String? email, BuildContext context) {
    final value = email?.trim() ?? '';
    final translations = context.loc;
    if (value.isEmpty) {
      return translations.email_address_is_empty;
    }

    final emailAddressPattern = RegExp(r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}'
        r'\@'
        r'[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}'
        r'('
        r'\.'
        r'[a-zA-Z0-9][a-zA-Z0-9\-]{0,25}'
        r')+');
    // final emailRegex = RegExp(
    // "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$");
    if (!emailAddressPattern.hasMatch(value)) {
      return translations.please_enter_valid_email_address;
    }
    return null;
  }

  static String? validatePassword(String? password, BuildContext context) {
    final translations = context.loc;
    final value = password?.trim() ?? '';
    if (value.isEmpty) return translations.password_should_not_be_empty;
    final bool isMoreThan8 = value.length < 8;
    if (isMoreThan8) {
      return translations.password_should_be_at_least_8_chars;
    }
    final bool isLessThan128 = value.length < 128;
    if (!isLessThan128) {
      return translations.password_should_be_less_than_128_chars;
    }
    final bool hasOneUppercase = value.contains(RegExp(r'[A-Z]'));
    final bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    final bool hasDigit = value.contains(RegExp(r'[0-9]'));
    final bool hasSpecialChar = value.contains(RegExp(r'[#?!@$%^&*-]'));

    if (!hasOneUppercase) {
      return translations
          .password_must_contain_at_least_one_uppercase_character;
    }

    if (!hasLowercase) {
      return translations
          .password_must_contain_at_least_one_lowercase_character;
    }

    if (!hasDigit) {
      return translations.password_must_contain_at_least_one_digit;
    }

    if (!hasSpecialChar) {
      return translations.password_must_contain_at_least_one_special_character;
    }

    final passwordRegex = RegExp(PatternsConstants.passwordPattern);
    if (!passwordRegex.hasMatch(value)) {
      return translations.password_should_be_strong;
    }
    return null;
  }

  static String? validateConfirmPassword({
    required BuildContext context,
    String? password,
    String? confirmPassword,
  }) {
    final translations = context.loc;
    if (password!.trim().isEmpty || confirmPassword!.trim().isEmpty) {
      return translations.password_should_not_be_empty;
    }
    if (password != confirmPassword) {
      return translations.confirm_password_does_not_match;
    }
    return null;
  }

  static const phoneNumberPattern = r'^07\d{9}$';
  static String? validatePhoneNumber(
      String? phoneNumber, BuildContext context) {
    final translations = context.loc;
    final value = phoneNumber?.trim() ?? '';
    if (value.isEmpty) {
      return translations.phone_number_should_not_be_empty;
    }
    final phoneNumberRegex = RegExp(phoneNumberPattern);
    if (!phoneNumberRegex.hasMatch(value)) {
      return translations.phone_number_must_be_valid;
    }
    return null;
  }
}
