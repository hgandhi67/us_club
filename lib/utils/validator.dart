
class Validator {
  static bool validateText(String name, {int length}) {
    if (name == null || name == '') {
      return null;
    }

    if (length != null) {
      if (name.length < length) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return value != '' ? regex.hasMatch(value) : null;
  }

  static bool validatePassword(String value) {
    return value != '' ? value.isNotEmpty && value.length >= 6 : null;
  }

  static bool phoneValidator(String phone) {
    String pattern = r'(^(?:[+0]9)?[0-9]{7,15}$)';
    RegExp regExp = new RegExp(pattern);

    if (phone != '') {
      if (phone.length == 0) {
        return false;
      } else if (!regExp.hasMatch(phone)) {
        return false;
      }
      return true;
    } else {
      return null;
    }
  }

  static bool validateName(String name) {

    if (name.isEmpty) return false;

    String pattern = r'[a-zA-Z]+';
    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(name);
  }

  ///:: CODE COMMIT 08-01-21
}
