import 'package:intl/intl.dart';


class TFormatters {
    static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formateCurrency(double amount) {
    return NumberFormat.currency(locale: 'en-US', symbol: 'LKR ').format(amount);
  }

  static String formatePhoneNumber(String phoneNumber){

    if(phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0,3)}) ${phoneNumber.substring(3,6)} ${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 1) {
      return '(${phoneNumber.substring(0,4)}) ${phoneNumber.substring(4,7)} ${phoneNumber.substring(7)}';
    }

    return phoneNumber;
  }


  static String interNationalFormatPhoneNumber(String phoneNumber) {
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    String countryCode = '+${digitsOnly.substring(0,2)}';
    digitsOnly = digitsOnly.substring(2);

    final formattedNumbers = StringBuffer();
    formattedNumbers.write('($countryCode)');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;
      if( i == 0 && countryCode == '+1') {
        groupLength = 3;
      }

      int end = i + groupLength;
      formattedNumbers.write(digitsOnly.substring(i,end));

      if (end < digitsOnly.length) {
        formattedNumbers.write(' ');
      }
      i = end;
    }
    return phoneNumber;
  }

}