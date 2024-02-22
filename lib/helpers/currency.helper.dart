import 'package:intl/intl.dart';

/// The `CurrencyHelper` class in Dart provides methods to format currency amounts with optional symbol,
/// name, and locale parameters.
class CurrencyHelper {
  /// The `format` function in Dart takes a double amount and optional parameters for symbol, name, and
  /// locale to format the amount with commas and a specified symbol.
  /// 
  /// Args:
  ///   amount (double): The `amount` parameter is a double value representing the numerical amount that
  /// you want to format.
  ///   symbol (String): The `symbol` parameter in the `format` function is used to specify the currency
  /// symbol that will be displayed with the formatted amount. In the provided code snippet, the default
  /// currency symbol is set to "₹" (Indian Rupee symbol). Defaults to ₹
  ///   name (String): The `name` parameter in the `format` function represents the currency name or
  /// code. In this case, the default value for `name` is "INR", which stands for Indian Rupee. Defaults
  /// to INR
  ///   locale (String): The `locale` parameter in the `format` function specifies the locale to be used
  /// for formatting the number. In this case, the default locale is set to "en_IN", which represents
  /// English language and India as the country. This locale setting helps in formatting the number
  /// according to the specific conventions and. Defaults to en_IN
  /// 
  /// Returns:
  ///   The `format` function returns a formatted string of the `amount` parameter with the specified
  /// symbol, name, and locale. The formatted amount is returned as a string.
  static String format(
      double amount, {
        String? symbol = "₹",
        String? name = "INR",
        String? locale = "en_IN",
      }) {
    return NumberFormat('##,##,##,###.####$symbol', locale).format(amount);
  }
  /// The `formatCompact` function in Dart formats a double amount into a compact representation with
  /// optional symbol, name, and locale parameters.
  /// 
  /// Args:
  ///   amount (double): The `amount` parameter is a double value representing the numerical amount that
  /// you want to format in a compact form.
  ///   symbol (String): The `symbol` parameter is used to specify the currency symbol that will be
  /// displayed before the formatted amount. In the provided code snippet, the default currency symbol
  /// is set to "₹" (Indian Rupee symbol). Defaults to ₹
  ///   name (String): The `name` parameter in the `formatCompact` function is a String parameter that
  /// represents the currency name. In this case, the default value for `name` is set to "INR", which
  /// stands for Indian Rupee. Defaults to INR
  ///   locale (String): The `locale` parameter in the `formatCompact` function is used to specify the
  /// locale for formatting the number. In this case, the default locale is set to "en_IN", which
  /// represents English language and India as the country. This helps in formatting the number
  /// according to the specific locale's number. Defaults to en_IN
  /// 
  /// Returns:
  ///   The function `formatCompact` is returning a formatted string of the `amount` parameter using
  /// compact number formatting based on the specified `locale`. The formatted amount is concatenated
  /// with the `symbol` if provided, otherwise an empty string is used.
  static String formatCompact(double amount, {
    String? symbol = "₹",
    String? name = "INR",
    String? locale = "en_IN",
  }){
    return NumberFormat.compact(locale: locale).format(amount)+(symbol ?? "") ;
  }
}

