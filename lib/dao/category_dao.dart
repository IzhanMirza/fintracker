import 'dart:async';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The `CategoryDao` class provides methods for CRUD operations on categories in a database, including
/// creating, finding with optional summary, updating, upserting, and deleting categories.
class CategoryDao {
  /// The function `create` inserts a new category object into a database table named "categories" and
  /// returns a Future<int> representing the result of the insertion operation.
  /// 
  /// Args:
  ///   category (Category): The `category` parameter is an object of type `Category` that represents a
  /// category entity. It is used to insert the category data into a database table named "categories".
  /// 
  /// Returns:
  ///   The `create` function is returning a `Future<int>`. This means that it is returning a Future
  /// that will eventually resolve to an integer value.
  Future<int> create(Category category) async {
    final db = await getDBInstance();
    var result = db.insert("categories", category.toJson());
    return result;
  }

/// This Dart function retrieves a list of categories with optional summary information based on a
/// specified date range.
/// 
/// Args:
///   withSummery (bool): The `withSummery` parameter is a boolean flag that determines whether to
/// include a summary of expenses for each category in the result. If `withSummery` is set to `true`,
/// the query will calculate the total expenses for each category within a specified date range. If
/// `with. Defaults to true
///   range (DateTimeRange): The `range` parameter in the `find` method is used to specify a date range
/// for filtering the data. It is of type `DateTimeRange`, which allows you to define a start and end
/// date/time range. If the `range` parameter is provided, the method will retrieve data within that
/// 
/// Returns:
///   A `Future<List<Category>>` is being returned.
  Future<List<Category>> find({ bool withSummery = true, DateTimeRange? range }) async {
    final db = await getDBInstance();

    List<Map<String, dynamic>> result;
    if(withSummery){
      String fields = [
        "c.id","c.name","c.icon","c.color", "c.budget",
        "SUM(CASE WHEN t.type='DR' AND t.category=c.id THEN t.amount END) as expense"
      ].join(",");
      DateTime from = range!=null ? range.start : DateTime(DateTime.now().year, DateTime.now().month,1,0,0);
      DateTime to =  range!=null ? range.end : DateTime.now().add(const Duration(days: 1));
      DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm");
      String sql = "SELECT $fields FROM categories c "
          "LEFT JOIN payments t ON t.category = c.id AND t.datetime BETWEEN DATE('${formatter.format(from)}') AND DATE('${formatter.format(to)}')"
          "GROUP BY c.id ";
      result = await db.rawQuery(sql);
    } else {
      result = await db.query("categories",);
    }
    List<Category> categories =[];
    if (result.isNotEmpty) {
      categories = result.map((item) => Category.fromJson(item)).toList();
    }
    return categories;
  }

  /// The function `update` updates a category in the database using its ID.
  /// 
  /// Args:
  ///   category (Category): The `category` parameter is an object of type `Category` that represents a
  /// category entity. It is used to update the corresponding record in the "categories" table in the
  /// database.
  /// 
  /// Returns:
  ///   The `update` method is returning a `Future<int>`, which represents the number of rows affected
  /// by the update operation in the database.
  Future<int> update(Category category) async {
    final db = await getDBInstance();

    var result = await db.update("categories", category.toJson(), where: "id = ?", whereArgs: [category.id]);

    return result;
  }

  /// The function `upsert` checks if a category has an ID and either updates or creates it accordingly.
  /// 
  /// Args:
  ///   category (Category): The `upsert` function takes a `Category` object as a parameter. The
  /// function checks if the `id` property of the `Category` object is not null. If the `id` is not
  /// null, it calls the `update` function with the `Category` object as an argument
  /// 
  /// Returns:
  ///   The `upsert` function is returning a `Future<int>`. This `Future<int>` represents the result of
  /// either updating or creating a `Category` object based on the provided input.
  Future<int> upsert(Category category) {
    if(category.id !=null){
      return update(category);
    } else {
      return create(category);
    }
  }


  /// The `delete` function deletes a record from the "categories" table in a database based on the
  /// provided ID.
  /// 
  /// Args:
  ///   id (int): The `id` parameter is the unique identifier of the category that you want to delete
  /// from the database.
  /// 
  /// Returns:
  ///   The `delete` method is returning a `Future<int>`, which means it is returning a Future that will
  /// eventually resolve to an integer value. This integer value represents the number of rows deleted
  /// from the "categories" table where the id matches the provided id parameter.
  Future<int> delete(int id) async {
    final db = await getDBInstance();
    var result = await db.delete("categories", where: 'id = ?', whereArgs: [id]);
    return result;
  }

  /// The function `deleteAll` deletes all records from the "categories" table in a database.
  /// 
  /// Returns:
  ///   The `deleteAll()` function is returning the result of the deletion operation performed on the
  /// "categories" table in the database. This result typically indicates the number of rows that were
  /// affected or deleted as a result of the operation.
  Future deleteAll() async {
    final db = await getDBInstance();
    var result = await db.delete(
      "categories",
    );
    return result;
  }
}