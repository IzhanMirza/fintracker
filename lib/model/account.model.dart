import 'package:flutter/material.dart';

/// The `Account` class represents a financial account with various properties like name, holder name,
/// account number, icon, color, balance, income, and expense.
class Account {
  /// These lines are defining the properties of the `Account` class in Dart. Here's a breakdown of each
  /// property:
  int? id;
  String name;
  String holderName;
  String accountNumber;
  IconData icon;
  Color color;
  bool? isDefault;
  double? balance;
  double? income;
  double? expense;

  /// This is the constructor for the `Account` class in Dart. It is a named constructor that allows you
  /// to create an instance of the `Account` class with specified parameters. Here's a breakdown of what
  /// each parameter does:
  Account({
    this.id,
    required this.name,
    required this.holderName,
    required this.accountNumber,
    required this.icon,
    required this.color,
    this.isDefault,
    this.income,
    this.expense,
    this.balance
  });



  /// This Dart factory method creates an Account object from a JSON map by parsing the data and
  /// initializing the Account properties.
  /// 
  /// Args:
  ///   data (Map<String, dynamic>): The `data` parameter in the `fromJson` factory method is a map that
  /// contains key-value pairs of the account information. The keys in the map correspond to the
  /// properties of the `Account` class that need to be populated with the data from the map.
  factory Account.fromJson(Map<String, dynamic> data) => Account(
    id: data["id"],
    name: data["name"],
    holderName: data["holderName"] ??"",
    accountNumber: data["accountNumber"]??"",
    icon: IconData(data["icon"], fontFamily: 'MaterialIcons'),
    color: Color(data["color"]),
    isDefault: data["isDefault"]==1?true:false,
    income: data["income"],
    expense: data["expense"],
    balance: data["balance"],
  );

  /// This function converts object properties to a map with string keys and dynamic values in Dart.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "holderName": holderName,
    "accountNumber": accountNumber,
    "icon": icon.codePoint,
    "color": color.value,
    "isDefault": (isDefault??false) ? 1:0
  };
}