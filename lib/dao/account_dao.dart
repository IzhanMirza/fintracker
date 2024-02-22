import 'dart:async';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:sqflite/sqflite.dart';

/// The `AccountDao` class contains a method to create a new account in a database asynchronously.
class AccountDao {
  Future<int> create(Account account) async {
    final db = await getDBInstance();
    var result = await db.insert("accounts", account.toJson());
    return result;
  }

  /// The `find` method in the `AccountDao` class is responsible for retrieving a list of accounts from
  /// the database. It has an optional parameter `withSummery` which defaults to `false`.
  Future<List<Account>> find({  bool withSummery=false}) async {
    /// `final Database db = await getDBInstance();` is a line of code in the `AccountDao` class that is
    /// asynchronously getting an instance of the database. The `getDBInstance()` function is being
    /// called to retrieve the database instance, and the `await` keyword is used to wait for the
    /// database instance to be returned before assigning it to the `db` variable. This allows the `db`
    /// variable to hold a reference to the database instance, which can then be used to perform
    /// database operations like querying, inserting, updating, or deleting data.
    final Database db = await getDBInstance();

    /// The line `List<Map<String, dynamic>> result;` in the `find` method of the `AccountDao` class is
    /// declaring a variable named `result` that will hold a list of maps where the keys are of type
    /// `String` and the values are of type `dynamic`. This variable is used to store the results
    /// retrieved from the database query or raw query operation performed within the `find` method. The
    /// `dynamic` type allows the values in the map to be of any data type.
    List<Map<String, dynamic>> result;

    /// The `if(withSummery)` block in the `find` method of the `AccountDao` class is responsible for
    /// constructing a SQL query based on the value of the `withSummery` parameter.
    if(withSummery){
      String fields = [
        "a.id","a.name","a.holderName","a.accountNumber","a.icon","a.color","a.isDefault",
        "SUM(CASE WHEN t.type='DR' AND t.account=a.id THEN t.amount END) as expense",
        "SUM(CASE WHEN t.type='CR' AND t.account=a.id THEN t.amount END) as income"
      ].join(",");
      String sql = "SELECT $fields FROM accounts a LEFT JOIN payments t ON t.account = a.id GROUP BY a.id";
      result = await db.rawQuery(sql);
    } 
    
    /// The `else` block with `result = await db.query("accounts",);` in the `find` method of the
    /// `AccountDao` class is responsible for executing a database query to retrieve all records from
    /// the "accounts" table when the `withSummery` parameter is `false`.
    else {
      result = await db.query("accounts",);
    }

    /// This block of code is responsible for processing the results retrieved from the database query
    /// and mapping them to a list of `Account` objects. Here's a breakdown of what it does:
    List<Account> accounts = [];
    if (result.isNotEmpty) {
      accounts = result.map((item) {
        Map<String, dynamic> nItem = Map.from(item);
        if(withSummery) {
          nItem["income"] = nItem["income"] ?? 0.0;
          nItem["expense"] = nItem["expense"]??0.0;
          nItem["balance"] = double.parse((nItem["income"] - nItem["expense"]).toString());
        }
        return Account.fromJson(nItem);
      }).toList();
    }
    return accounts;
  }

  /// The function `update` updates an account record in a database table using the account's ID.
  /// 
  /// Args:
  ///   account (Account): The `account` parameter is an instance of the `Account` class, which is being
  /// passed to the `update` method for updating the corresponding record in the "accounts" table in the
  /// database. The `toJson()` method is likely used to convert the `Account` object into a JSON format
  /// before
  /// 
  /// Returns:
  ///   The `update` method is returning a `Future<int>`, which means it is returning a Future that will
  /// eventually resolve to an integer value. This integer value represents the number of rows affected
  /// by the update operation in the database.
  Future<int> update(Account account) async {
    final db = await getDBInstance();
    var result = await db.update("accounts", account.toJson(), where: "id = ?", whereArgs: [account.id]);
    return result;
  }

  /// The function `upsert` checks if an account already exists and either updates it or creates a new
  /// one accordingly.
  /// 
  /// Args:
  ///   account (Account): The `account` parameter is an object of type `Account` which represents an
  /// account entity. It likely contains information such as an account ID, account holder name, account
  /// balance, etc. The `upsert` function is a method that either updates an existing account if it
  /// already has an ID or
  /// 
  /// Returns:
  ///   The `upsert` function returns a `Future<int>`, which is the result of either updating or
  /// creating an account based on the provided `Account` object.
  Future<int> upsert(Account account) async {
    if(account.id !=null) {
      return  await update(account);
    } else {
      return await create(account);
    }
  }



  /// The `delete` function deletes a record from the "accounts" table and related records from the
  /// "payments" table based on the provided ID.
  /// 
  /// Args:
  ///   id (int): The `id` parameter is the unique identifier of the account that you want to delete
  /// from the database.
  /// 
  /// Returns:
  ///   The `delete` method is returning a `Future<int>`, which represents the number of rows affected
  /// by the delete operation in the database table "accounts".
  Future<int> delete(int id) async {
    final db = await getDBInstance();
    var result = await db.delete("accounts", where: 'id = ?', whereArgs: [id]);
    await db.delete("payments", where: "account = ?", whereArgs:[id]);
    return result;
  }
}