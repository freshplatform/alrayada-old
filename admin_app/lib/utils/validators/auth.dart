abstract class AuthValidators {
  static String? validateEmail(String? email) {
    final value = email?.trim() ?? '';
    if (value.isEmpty) {
      return 'Email address is empty';
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
      return 'Enter a valid e-mail address';
    }
    return null;
  }

  static const passwordPattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@\$%^&*-]).{8,}\$';
  static String? validatePassword(String? password) {
    final value = password?.trim() ?? '';
    if (value.isEmpty) return 'Password should not be empty';
    if (value.length < 8) return 'Password should be at least 8 characters';
    if (value.length > 255) {
      return 'Password should be less than 255 characters';
    }
    final passwordRegex = RegExp(passwordPattern);
    if (passwordRegex.hasMatch(value)) {
      return 'Password should be strong';
    }
    return null;
  }

  static String? validateConfirmPassword({
    String? password,
    String? confirmPassword,
  }) {
    if (password!.trim().isEmpty || confirmPassword!.trim().isEmpty) {
      return 'Confirm password should not be empty';
    }
    if (password != confirmPassword) {
      return "Password doesn't match";
    }
    return null;
  }

  static const phoneNumberPattern = r'^07\d{9}$';
  static String? validatePhoneNumber(String? phoneNumber) {
    final value = phoneNumber?.trim() ?? '';
    if (value.isEmpty) {
      return "Phone number shouldn't be empty";
    }
    final phoneNumberRegex = RegExp(phoneNumberPattern);
    if (!phoneNumberRegex.hasMatch(value)) {
      return 'Enter valid phone number';
    }
    return null;
  }
}
