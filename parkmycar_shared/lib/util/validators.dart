class Validators {
  /// Validate if a String? contains a valid number for id. Valid number value are 1-99999.
  static bool isValidId(String? value) {
    if (value != null && RegExp(r'^[1-9]|[1-9][0-9]{1,4}$').hasMatch(value)) {
      return true;
    }
    return false;
  }

  /// Valid value = string with minimum of 1 letter, max 255
  static bool isValidName(String? value) {
    if (value != null && value.isNotEmpty && value.length <= 255) {
      return true;
    }
    return false;
  }

  /// Valid value = "YYYYMMDD-NNNN"
  static bool isValidPersonNr(String? value) {
    if (value != null &&
        RegExp(r'^(((([02468][048]|[13579][26])00|\d\d(0[48]|[2468][048]|[13579][26]))02[28]9)|(\d{4}((0[135789]|1[02])([06][1-9]|[1278]\d|[39][01])|(0[469]|11)([06][1-9]|[1278]\d|[39]0)|(02([06][1-9]|[17]\d|[28][0-8])))))\d{4}$')
            .hasMatch(value)) {
      return true;
    }
    return false;
  }

  /// Valid value = string with minimum of 1 letter, max 1000
  static bool isValidAddress(String? value) {
    if (value != null && value.isNotEmpty && value.length <= 1000) {
      return true;
    }
    return false;
  }

  /// Valid value number from 0-99999
  static bool isValidPricePerHour(String? value) {
    if (value != null && RegExp(r'^[0-9]{1,4}$').hasMatch(value)) {
      return true;
    }
    return false;
  }

  /// Valid value = "YYYY-MM-DD HH:MM"
  static bool isValidDateTime(String? value) {
    if (value != null &&
        RegExp(r'^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]$')
            .hasMatch(value)) {
      return true;
    }
    return false;
  }

  /// Valid value = "NNNXXX"
  static bool isValidRegNr(String? value) {
    if (value != null &&
        RegExp(r'^[A-Za-z]{3}[0-9]{2}[A-Za-z0-9]{1}$').hasMatch(value)) {
      return true;
    }
    return false;
  }
}
