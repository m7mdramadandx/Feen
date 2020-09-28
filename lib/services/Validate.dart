class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'أدخل الأسم العائلة';
    } else if (value.length < 2) {
      return 'أدخل الأسم بشكل صحيح';
    } else if (value.length > 50) {
      return 'أدخل الأسم بشكل صحيح';
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'ادخل البريد الإلكتروني';
    }
    if (regex.hasMatch(value)) {
      return null;
    } else {
      return 'أدخل بريد إلكتروني بشكل صحيح';
    }
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'أدخل كلمة المرور';
    }
    /*else {
      String pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(value)) {
        return null;
      } else {
        return 'التحقق من صحة كلمة المرور';
      }
    }*/
    return null;
  }
}

class ConfirmPasswordValidator {
  static String validate(String password, String value) {
    if (value.isEmpty) {
      return 'أدخل كلمة المرور';
    } else {
      if (password != value) {
        return 'كلمتين المرور غير متطابقتين';
      }
      return null;
    }
  }
}

class PhoneNumberValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'أدخل رقم الهاتف';
    } else {
      if (value.length != 11) {
        return 'أدخل رقم الهاتف بشكل صحيح';
      }
      return null;
    }
  }
}

class EditNameValidator {
  static String validate(String value) {
    if (value.length < 2) {
      return 'أدخل الأسم بشكل صحيح';
    } else if (value.length > 50) {
      return 'أدخل الأسم بشكل صحيح';
    }
    return null;
  }
}

class EditPhoneNumberValidator {
  static String validate(String value) {
    if (value.length != 11) {
      return 'أدخل رقم الهاتف بشكل صحيح';
    }
    return null;
  }
}
