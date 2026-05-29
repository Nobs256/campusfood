import 'package:intl/intl.dart';

class AppFormatters {
  static String formatPrice(double price) {
    final formatter = NumberFormat.currency(symbol: 'UGX ', decimalDigits: 0);
    return formatter.format(price);
  }
}
