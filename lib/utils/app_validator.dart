class AppValidators {
  static String? validateMobile(value, {bool allowEmpty = false}) {
    const String kEmptyValidator = "Phone Number can't be empty.";
    const String kValidValidator = "Phone Number is invalid.";
    if (value == null || value.isEmpty && !allowEmpty) {
      return kEmptyValidator;
    }
    if ((value == null || value.isEmpty) && allowEmpty) {
      return null;
    }
    String pattern = r"^[6-9]\d{9}$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return kValidValidator;
    }

    return null;
  }

  static String? validateChips(value) {
    if (value == null) {
      return "Field is required";
    }

    return null;
  }

  static String? validateEmail(value, {bool allowEmpty = false}) {
    const String kEmptyValidator = "Email can't be empty.";
    const String kValidValidator = "Email is invalid.";
    if (value == null || value.isEmpty && !allowEmpty) {
      return kEmptyValidator;
    }
    if ((value == null || value.isEmpty) && allowEmpty) {
      return null;
    }
    String pattern = r"^([a-zA-Z0-9_\-\.\+]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return kValidValidator;
    }

    return null;
  }

  static String? validateOTP(value) {
    const String kEmptyValidator = "Enter Valid OTP.";
    const String kValidValidator = "OTP must be of 6 digit.";
    if (value == null || value.isEmpty) {
      return kEmptyValidator;
    }
    String pattern = r"^\d{6}$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return kValidValidator;
    }

    return null;
  }

  static String? validateNumeric(value) {
    const String kEmptyValidator = "Enter Valid No";

    if (value == null || value.isEmpty) {
      return kEmptyValidator;
    }
    String pattern = r"^[0-9]+$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return kEmptyValidator;
    }

    return null;
  }

  static String? requiredDropdown(value) {
    const String kEmptyValidator = "This field is required.";

    if (value == null) {
      return kEmptyValidator;
    }

    return null;
  }

  static String? requiredFiled(value) {
    const String kEmptyValidator = "This field is required.";

    if (value == null || value.isEmpty) {
      return kEmptyValidator;
    }

    return null;
  }

  static String? validateDescription(String? value) {
    const String kValidValidator = "Enter valid description";
    if (value == null || value.contains('<') || value.contains('>') || value.isEmpty) {
      return kValidValidator;
    }

    return null;
  }
}
