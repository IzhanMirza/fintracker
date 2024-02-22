import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

/// The `safeDouble` function attempts to parse a dynamic value into a double and returns 0 if an error
/// occurs.
/// 
/// Args:
///   value (dynamic): The `value` parameter in the `safeDouble` function is of type `dynamic`, which
/// means it can hold values of any data type. The function attempts to parse the value as a double
/// using `double.parse(value)`. If parsing is successful, it returns the parsed double value. If an
/// 
/// Returns:
///   If the `value` can be successfully parsed into a double, then the parsed double value will be
/// returned. If there is an error during parsing (for example, if the `value` is not a valid double),
/// then 0 will be returned.
double safeDouble(dynamic value){
  try{
    return double.parse(value);
  }catch(err){
    return 0;
  }
}
/// The function `v1` creates three tables (`payments`, `categories`, `accounts`) in a database with
/// specific column definitions.
/// 
/// Args:
///   database (Database): The code you provided is a Dart function that creates three tables in a
/// database. The function takes a `Database` object as a parameter. The `Database` object is likely an
/// instance of a database connection or handler that allows you to interact with a SQLite database.
void v1(Database database) async {
  debugPrint("Running first migration....");
  await database.execute("CREATE TABLE payments ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "title TEXT NULL, "
      "description TEXT NULL, "
      "account INTEGER,"
      "category INTEGER,"
      "amount REAL,"
      "type TEXT,"
      "datetime DATETIME"
      ")");

  await database.execute("CREATE TABLE categories ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "name TEXT,"
      "icon INTEGER,"
      "color INTEGER,"
      "budget REAL NULL, "
      "type TEXT"
      ")");

  await database.execute("CREATE TABLE accounts ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "name TEXT,"
      "holderName TEXT NULL, "
      "accountNumber TEXT NULL, "
      "icon INTEGER,"
      "color INTEGER,"
      "isDefault INTEGER"
      ")");
}