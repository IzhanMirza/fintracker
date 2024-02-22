import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:intl/intl.dart';

/// The `enum PaymentType` in the Dart code snippet is defining a custom enumeration type called
/// `PaymentType` with two possible values: `debit` and `credit`. This enum is used to represent the
/// type of payment being made, where `debit` typically represents a payment outflow or deduction from
/// an account, and `credit` represents a payment inflow or addition to an account.
enum PaymentType {
  debit,
  credit
}
/// The `Payment` class represents a financial transaction with properties like id, account, category,
/// amount, type, datetime, title, and description, and includes methods for JSON
/// serialization/deserialization.
class Payment {
  int? id;
  Account account;
  Category category;
  double amount;
  PaymentType type;
  DateTime datetime;
  String title;
  String description;

  /// This code snippet defines a constructor for the `Payment` class in Dart. The constructor takes
  /// several parameters:
  Payment({
    this.id,
    required this.account,
    required this.category,
    required this.amount,
    required this.type,
    required this.datetime,
    required this.title,
    required this.description
  });


  /// The function `Payment.fromJson` parses a JSON map into a Payment object in Dart.
  /// 
  /// Args:
  ///   data (Map<String, dynamic>): The `data` parameter in the `fromJson` method is a `Map<String,
  /// dynamic>` that contains the information needed to create a `Payment` object. It includes key-value
  /// pairs where the keys are strings and the values are dynamic, allowing for flexibility in the data
  /// types that can be stored.
  /// 
  /// Returns:
  ///   A `Payment` object is being returned by the `fromJson` factory method. The `Payment` object is
  /// created using the data provided in the `Map<String, dynamic> data` parameter. The `id`, `title`,
  /// `description`, `account`, `category`, `amount`, `type`, and `datetime` properties of the `Payment`
  /// object are initialized using the corresponding values from the
  factory Payment.fromJson(Map<String, dynamic> data) {
    return Payment(
      id: data["id"],
      title: data["title"] ??"",
      description: data["description"]??"",
      account: Account.fromJson(data["account"]),
      category: Category.fromJson(data["category"]),
      amount: data["amount"],
      type: data["type"] == "CR" ? PaymentType.credit : PaymentType
          .debit,
      datetime: DateTime.parse(data["datetime"]),
    );
  }

  /// This function converts an object's properties into a JSON format with specific key-value pairs.
  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "account": account.id,
    "category": category.id,
    "amount": amount,
    "datetime": DateFormat('yyyy-MM-dd kk:mm:ss').format(datetime),
    "type": type == PaymentType.credit ? "CR": "DR",
  };
}