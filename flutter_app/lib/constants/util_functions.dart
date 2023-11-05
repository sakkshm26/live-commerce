import 'dart:ffi';

class UtilFunctions {
  String formatNumberWithCommas(num number) {
    final String numberStr = number.toString();
    final List<String> parts = numberStr.split('.');

    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    final StringBuffer formatted = StringBuffer();
    int count = 0;

    for (int i = integerPart.length - 1; i >= 0; i--) {
      formatted.write(integerPart[i]);
      count++;

      if (count == 3 && i != 0) {
        formatted.write(',');
        count = 0;
      }
    }

    final String reversedIntegerPart = formatted.toString().split('').reversed.join();

    if (decimalPart.isNotEmpty) {
      return '$reversedIntegerPart.$decimalPart';
    } else {
      return reversedIntegerPart;
    }
  }
}

class ServiceReturnType {
  final dynamic data;
  final String? errorMessage;

  ServiceReturnType({this.data, this.errorMessage});
}