
import "dart:io";
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:fintracker/helpers/migrations/migrations.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

/// The above Dart code defines functions to handle database operations including creating, upgrading,
/// and resetting a database with predefined categories and accounts.
/// 
/// Returns:
///   The `getDBInstance()` function returns a `Future<Database>` instance.
Database? database;
/// The function `getDBInstance` checks if a database instance exists, creates one if not, and returns
/// the database instance.
/// 
/// Returns:
///   A Future object that resolves to an instance of a Database when the database is successfully
/// initialized or retrieved.
Future<Database> getDBInstance() async {
  if(database == null) {
    Database db;
    if(Platform.isWindows){
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      db = await databaseFactory.openDatabase("database.db", options: OpenDatabaseOptions(
          version: 1,
          onCreate: onCreate,
          onUpgrade: onUpgrade
      ));
    } else {
      String databasesPath = await getDatabasesPath();
      String dbPath = join(databasesPath, 'database.db');
      db = await openDatabase(dbPath, version: 1, onCreate: onCreate, onUpgrade: onUpgrade);
    }

    database = db;
    return db;
  } else {
    Database db = database!;
    return db;
  }
}

/// The above Dart code defines a list of database migration callbacks and executes them when the
/// database is created.
/// 
/// Args:
///   database (Database): The `database` parameter is an instance of the `Database` class, which is
/// used to interact with a database in Flutter or Dart.
///   version (int): The `version` parameter in the `onCreate` function represents the version of the
/// database being created.
typedef MigrationCallback = Function(Database database);
List<MigrationCallback>migrations = [
  v1
];
void onCreate(Database database,  int version) async {
  for(MigrationCallback callback in migrations){
    await callback(database);
  }
}

/// The function `onUpgrade` iterates through a list of migrations and applies them to a database to
/// upgrade it from an old version to a new version.
/// 
/// Args:
///   database (Database): The `database` parameter is an object representing the database that needs to
/// be upgraded. It likely contains the data and schema of the database that will be modified during the
/// upgrade process.
///   oldVersion (int): The `oldVersion` parameter represents the current version of the database before
/// the upgrade process.
///   version (int): The `version` parameter in the `onUpgrade` method represents the new version of the
/// database schema that you are upgrading to. It is the version number that you want the database to be
/// upgraded to from the `oldVersion`.
void onUpgrade(Database database, int oldVersion, int version) async {
  for(int index = oldVersion; index < version; index++){
    MigrationCallback callback = migrations[index];
    await callback(database);
  }
}

/// The `resetDatabase` function resets the database by deleting existing data and inserting default
/// accounts and prefilling categories with icons and colors.
/// The `resetDatabase` function deletes all records in the "payments", "accounts", and "categories"
/// tables and inserts a default account record named "Cash".
Future<void> resetDatabase() async {
  Database database = await getDBInstance();
  database.delete("payments", where: "id>0");
  database.delete("accounts", where: "id>0");
  database.delete("categories", where: "id>0");

  await database.insert("accounts", {
    "name": "Cash",
    "icon": Icons.wallet.codePoint,
    "color": Colors.teal.value,
    "isDefault": 1
  });

  //prefill all categories
  /// The `List<Map<String, dynamic>> categories` is a list of maps where each map represents a category
  /// with its name and corresponding icon. Each map in the list has two key-value pairs: "name"
  /// representing the name of the category and "icon" representing the code point of the icon
  /// associated with that category.
  List<Map<String, dynamic>> categories = [
    {"name": "Housing", "icon": Icons.house.codePoint},
    {"name": "Transportation", "icon": Icons.emoji_transportation.codePoint},
    {"name": "Food", "icon": Icons.restaurant.codePoint},
    {"name": "Utilities", "icon": Icons.category.codePoint},
    {"name": "Insurance", "icon": Icons.health_and_safety.codePoint},
    {"name": "Medical & Healthcare", "icon": Icons.medical_information.codePoint},
    {"name": "Saving, Investing, & Debt Payments", "icon": Icons.attach_money.codePoint},
    {"name": "Personal Spending", "icon": Icons.house.codePoint},
    {"name": "Recreation & Entertainment", "icon": Icons.tv.codePoint},
    {"name": "Miscellaneous", "icon": Icons.library_books_sharp.codePoint},
  ];

  /// The code snippet `int index = 0; for(Map<String, dynamic> category in categories){ await
  /// database.insert("categories", { "name": category["name"], "icon": category["icon"], "color":
  /// Colors.primaries[index].value, }); index++; }` is iterating over a list of category maps and
  /// inserting each category into the "categories" table in the database.
  int index = 0;
  for(Map<String, dynamic> category in categories){
    await database.insert("categories", {
      "name": category["name"],
      "icon": category["icon"],
      "color": Colors.primaries[index].value,
    });
    index++;
  }
}

