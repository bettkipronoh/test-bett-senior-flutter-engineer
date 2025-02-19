import 'package:intl/intl.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(trim());
  }
}

extension PassWordValidator on String {
  bool isPassWordValid() {
    return trim().length > 5;
    // return RegExp(
    //     r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])?[A-Za-z\d@$!%*#?&]{6,}$')
    //     .hasMatch(this.trim());
  }
}

extension FullNamesValidator on String {
  bool isFullNameValid() {
    return RegExp(r'^\s*(\S+)\s+(\S+)\s*$').hasMatch(trim()) ||
        RegExp(r'^[a-zA-Z]+(?:[\s-][a-zA-Z]+){2}$').hasMatch(trim());
  }
}

extension PhoneValidator on String {
  bool isPhoneValid() {
    return RegExp(r'^\+?[0-9]{9,15}$').hasMatch(trim().replaceAll(' ', ''));
  }
}

extension NumberOnly on String {
  bool isNumberOnly() {
    return RegExp(r'^[0-9]').hasMatch(trim());
  }
}

extension NameValidator on String {
  bool isNameValid() {
    return RegExp(r'^[a-zA-Z 0-9]{3,}$').hasMatch(trim());
  }
}

extension BusinessNumberValidator on String {
  bool isBusinessNumberValid() {
    return RegExp(r'^[a-zA-Z0-9!@#$&()\-`.+,/]{3,}$').hasMatch(trim());
  }
}

extension PhoneNumberFormatter on String {
  String getPhoneNumber({required String country}) {
    bool startswithzero = startsWith('0');
    if (startswithzero) {
      String numberwithoutzero = replaceFirst(RegExp(r'0'), "");
      return "+$country$numberwithoutzero";
    } else {
      return "+$country$this";
    }
  }
}

extension PhoneNumberExtractor on String {
  String getNumberFromPhone(String country) {
    bool startsWithPlus = trim().startsWith('+');
    bool startsWithCountry = trim().startsWith(country);
    if (startsWithPlus || startsWithCountry) {
      if (startsWithPlus) {
        return replaceFirst('+$country', '').trim();
      } else {
        return replaceFirst(country, '').trim();
      }
    } else {
      return this;
    }
  }
}

var formatter = NumberFormat("#,##0", "en_US");

extension getFormattedCurrency on Object {
  String getCurrencyFromAmount() {
    Object? value = runtimeType is num ? this : double.tryParse(toString());
    if (value == null) return "";
    return double.parse(value.toString()) < 100
        ? "$value"
        : formatter.format(value);
  }
}

extension MpesaPhoneNumberFormatter on String {
  String getMpesaPhoneNumber({required String country}) {
    bool startswithzero = startsWith('0');
    if (startswithzero) {
      String numberwithoutzero = replaceFirst(RegExp(r'0'), "");
      return "$country$numberwithoutzero";
    } else {
      return "$country$this";
    }
  }
}

extension AccountValid on String {
  bool isAccountValid() {
    return RegExp(r'^(?=.*[A-Za-z0-9])(?=.*\d)[A-Za-z0-9\d]{7,}$')
        .hasMatch(trim());
  }
}

extension GetInitials on String {
  String getInitials() => isNotEmpty
      ? length < 2
          ? ''
          : trim()
              .split(' ')
              .map((l) => l.length < 1 ? '' : l[0])
              .take(2)
              .join()
      : '';
}

//
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension CapitalizeAll on String {
  String capitalizeFirstLetters() {
    return split(" ").length < 2
        ? capitalize()
        : (split(' ')
            .map((word) => word == 'and'
                ? '&'
                : word == 'or' || word == 'a' || word == 'MyHealth'
                    ? word
                    : word.isNotEmpty
                        ? word.capitalize()
                        : word)
            .join(' '));
  }
}
