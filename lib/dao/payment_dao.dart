import 'dart:async';
import 'package:fintracker/dao/account_dao.dart';
import 'package:fintracker/dao/category_dao.dart';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:fintracker/model/payment.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The `PaymentDao` class in Dart provides methods for interacting with a database to perform CRUD
/// operations on payment entities.
class PaymentDao {
  /// The function `create` inserts a payment object into a database table named "payments" and returns
  /// the result.
  ///
  /// Args:
  ///   payment (Payment): The `payment` parameter is an object of type `Payment` that is being passed
  /// to the `create` method. It is used to store payment information and is converted to JSON format
  /// using the `toJson` method before being inserted into the database table named "payments".
  ///
  /// Returns:
  ///   The `create` function is returning a `Future<int>`, which represents a future that will
  /// eventually resolve to an integer value. The integer value being returned is the result of
  /// inserting the payment data into the "payments" table in the database.
  Future<int> create(Payment payment) async {
    final db = await getDBInstance();
    var result = db.insert("payments", payment.toJson());
    return result;
  }

/// This Dart function finds payments based on specified criteria such as date range, type, category,
/// and account.
/// 
/// Args:
///   range (DateTimeRange): The `range` parameter is used to filter payments based on a specific date
/// range. If provided, the function will only retrieve payments that fall within the specified date
/// range.
///   type (PaymentType): The `type` parameter in the `find` method is used to filter payments based on
/// whether they are credit or debit transactions. If the `type` is `PaymentType.credit`, it filters for
/// credit transactions, otherwise, it filters for debit transactions.
///   category (Category): The `category` parameter in the `find` method is used to filter payments
/// based on a specific category. If a `Category` object is provided, the method will include a
/// condition in the SQL query to only retrieve payments that belong to the specified category.
///   account (Account): The `account` parameter in the `find` method is used to filter payments based
/// on a specific account. It is an instance of the `Account` class. If a value is provided for the
/// `account` parameter, the method will include a condition in the SQL query to only retrieve payments
/// associated
///   limit (int): The `limit` parameter in the `find` method specifies the maximum number of payment
/// records to retrieve from the database. It limits the number of results returned by the query. If the
/// `limit` parameter is set to a specific value, only that number of payment records will be fetched
/// from the database
///   offset (int): The `offset` parameter in the `find` method is used to specify the number of results
/// to skip before starting to return the results. It is typically used for pagination, where you can
/// retrieve a subset of results starting from a specific position in the result set.
/// 
/// Returns:
///   A `Future<List<Payment>>` is being returned.
  Future<List<Payment>> find({
    DateTimeRange? range,
    PaymentType? type,
    Category? category,
    Account? account,
    int? limit,
    int? offset,
  }) async {
    final db = await getDBInstance();
    String where = "";

    if (range != null) {
      where +=
          "AND datetime BETWEEN DATE('${DateFormat('yyyy-MM-dd kk:mm:ss').format(range.start)}') AND DATE('${DateFormat('yyyy-MM-dd kk:mm:ss').format(range.end.add(const Duration(days: 1)))}')";
    }

    //type check
    if (type != null) {
      where += "AND type='${type == PaymentType.credit ? "DR" : "CR"}' ";
    }

    //icon check
    if (account != null) {
      where += "AND account='${account.id}' ";
    }

    //icon check
    if (category != null) {
      where += "AND category='${category.id}' ";
    }

    //categories
    List<Category> categories = await CategoryDao().find();
    List<Account> accounts = await AccountDao().find();

    List<Payment> payments = [];
    List<Map<String, Object?>> rows = await db.query(
      "payments",
      orderBy: "datetime DESC, id DESC",
      where: "1=1 $where",
      limit: limit,
      offset: offset,
    );
    for (var row in rows) {
      Map<String, dynamic> payment = Map<String, dynamic>.from(row);
      Account account = accounts.firstWhere((a) => a.id == payment["account"]);
      Category category =
          categories.firstWhere((c) => c.id == payment["category"]);
      payment["category"] = category.toJson();
      payment["account"] = account.toJson();
      payments.add(Payment.fromJson(payment));
    }

    return payments;
  }

/// This Dart function counts the number of payments based on specified criteria such as date range,
/// payment type, category, account, limit, and offset.
/// 
/// Args:
///   range (DateTimeRange): The `range` parameter is used to specify a date and time range within which
/// you want to count the payments. It is of type `DateTimeRange?`, which means it can be a range of
/// dates and times or `null` if not provided.
///   type (PaymentType): The `type` parameter in the `count` function is used to filter payments based
/// on the payment type. If the `type` is `PaymentType.credit`, it filters payments with type "DR"
/// (debit), otherwise, it filters payments with type "CR" (credit).
///   category (Category): The `category` parameter in the `count` function is used to filter payments
/// based on a specific category. It is of type `Category?`, which means it can be either a valid
/// `Category` object or `null`. If a `Category` object is provided, the function will include a
///   account (Account): The `account` parameter in the `count` function is used to filter payments
/// based on a specific account. It checks if the payment belongs to the account specified in the
/// parameter.
///   limit (int): The `limit` parameter in the `count` function specifies the maximum number of records
/// to be returned by the query. It limits the number of results that will be counted and returned by
/// the function. If the `limit` parameter is not provided, all matching records will be counted.
///   offset (int): The `offset` parameter in the `count` function is used to specify the number of rows
/// to skip before starting to count the total number of rows that meet the specified conditions. It is
/// typically used in conjunction with the `limit` parameter to implement pagination in database
/// queries.
/// 
/// Returns:
///   The `count` method is returning the total count of payments based on the provided filters such as
/// range, type, category, account, limit, and offset. It queries the database table "payments" with the
/// specified conditions and returns the count of rows that match those conditions. The count is
/// extracted from the query result and returned as an integer value. If no rows match the conditions,
/// it will return
  Future<int> count(
      {DateTimeRange? range,
      PaymentType? type,
      Category? category,
      Account? account,
      int? limit,
      int? offset}) async {
    final db = await getDBInstance();
    String where = "";

    if (range != null) {
      where +=
          "AND datetime BETWEEN DATE('${DateFormat('yyyy-MM-dd kk:mm:ss').format(range.start)}') AND DATE('${DateFormat('yyyy-MM-dd kk:mm:ss').format(range.end.add(const Duration(days: 1)))}')";
    }

    //type check
    if (type != null) {
      where += "AND type='${type == PaymentType.credit ? "DR" : "CR"}' ";
    }

    //icon check
    if (account != null) {
      where += "AND account='${account.id}' ";
    }

    //icon check
    if (category != null) {
      where += "AND category='${category.id}' ";
    }

    List<Map<String, Object?>> rows = await db.query("payments",
        where: "1=1 $where",
        limit: limit,
        offset: offset,
        columns: ["count(*) as count"]);
    return (rows[0]["count"] as int?) ?? 0;
  }

  /// The `update` function updates a payment record in the database using the provided Payment object.
  /// 
  /// Args:
  ///   payment (Payment): The `payment` parameter is an object of type `Payment` that contains
  /// information about a payment transaction. It is used to update a payment record in the database
  /// table named "payments". The `payment` object is converted to a JSON format before being passed to
  /// the database update operation.
  /// 
  /// Returns:
  ///   The `update` method is returning a `Future<int>`, which represents a future that will eventually
  /// resolve to an integer value. This integer value typically represents the number of rows affected
  /// by the update operation in the database.
  Future<int> update(Payment payment) async {
    final db = await getDBInstance();

    var result = await db.update("payments", payment.toJson(),
        where: "id = ?", whereArgs: [payment.id]);

    return result;
  }

/// The `upsert` function in Dart performs an insert or update operation on a Payment object in a
/// database based on whether the payment already has an ID.
/// 
/// Args:
///   payment (Payment): The `upsert` function you provided is used to update or insert a `Payment`
/// object into a database table named "payments". The function takes a `Payment` object as a parameter
/// and performs an update operation if the `id` of the payment is not null, otherwise it performs an
/// insert
/// 
/// Returns:
///   The `upsert` function is returning a `Future<int>`, which represents the result of the database
/// operation (either the number of rows updated or the ID of the newly inserted row).
  Future<int> upsert(Payment payment) async {
    final db = await getDBInstance();
    int result;
    if (payment.id != null) {
      result = await db.update("payments", payment.toJson(),
          where: "id = ?", whereArgs: [payment.id]);
    } else {
      result = await db.insert("payments", payment.toJson());
    }

    return result;
  }

  /// This Dart function deletes a transaction from a database table named "payments" based on the
  /// provided ID.
  /// 
  /// Args:
  ///   id (int): The `id` parameter in the `deleteTransaction` function represents the unique
  /// identifier of the transaction that you want to delete from the "payments" table in the database.
  /// This parameter is used to specify which transaction should be deleted based on its ID.
  /// 
  /// Returns:
  ///   The `deleteTransaction` function returns a `Future<int>`, which represents the result of
  /// deleting a transaction with the specified ID from the "payments" table in the database. The result
  /// is the number of rows affected by the delete operation.
  Future<int> deleteTransaction(int id) async {
    final db = await getDBInstance();
    var result = await db.delete("payments", where: 'id = ?', whereArgs: [id]);
    return result;
  }

  /// The function `deleteAllTransactions` deletes all records from the "payments" table in a database.
  /// 
  /// Returns:
  ///   The `deleteAllTransactions()` function is returning the result of the deletion operation
  /// performed on the "payments" table in the database. This result typically indicates the number of
  /// rows that were affected or deleted as a result of the operation.
  Future deleteAllTransactions() async {
    final db = await getDBInstance();
    var result = await db.delete(
      "payments",
    );
    return result;
  }
}