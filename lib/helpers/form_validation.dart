// ignore_for_file: no_leading_underscores_for_local_identifiers

abstract class FormInputsValidation {
  static String? validateEmail(String? _value) {
    String value = _value?.trim() ?? '';
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

  static String? validateUsername(String? _value) {
    String value = _value?.trim() ?? '';
    const minLength = 3;
    const maxLength = 16;
    if (value.isEmpty) {
      return 'Username is empty';
    }
    if (value.length < minLength) {
      return 'Please enter username above or equal 3 characters';
    }
    if (value.length > maxLength) {
      return 'Please enter username less or equal 16 characters';
    }
    final usernameRegex = RegExp('^[a-zA-Z0-9._-]{$minLength,$maxLength}\$');
    if (!usernameRegex.hasMatch(value)) return 'Enter a valid username';
    return null;
  }

  static String? validatePassword(String? _value) {
    String value = _value?.trim() ?? '';
    if (value.isEmpty) return 'Password should not be empty';
    if (value.length < 8) return 'Password should be at least 8 characters';
    if (value.length > 255) {
      return 'Password should be less than 255 characters';
    }
    // final passwordRegex =
    //     RegExp('^(?=.*[a-z])(?=.*[A-Z])(?=.*d)[a-zA-Zd]{8,255}\$');
    // if (!passwordRegex.hasMatch(value)) {
    //   return 'Please enter a valid password';
    // }
    return null;
  }
}

// abstract class FormInputsValidationInterface {
//   String? validateEmail(String? _value);
//   String? validateUsername(String? _value);
//   String? validatePassword(String? _value);
// }
