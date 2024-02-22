import 'package:flutter/material.dart';

/// The Category class represents a category with properties such as id, name, icon, color, budget, and
/// expense, and includes methods for converting to and from JSON format.
class Category {
  /// These lines are declaring instance variables for the `Category` class in Dart. Here's what each
  /// variable represents:
  int? id;
  String name;
  IconData icon;
  Color color;
  double? budget;
  double? expense;

  /// This code snippet defines a constructor for the `Category` class in Dart. The constructor takes
  /// several parameters:
  Category({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.budget,
    this.expense
  });

  /// This factory method creates a Category object from a JSON map by extracting and converting the
  /// necessary data.
  /// 
  /// Args:
  ///   data (Map<String, dynamic>): The `data` parameter is a map that contains key-value pairs where
  /// the keys are strings and the values are dynamic types. This map is used to extract the necessary
  /// information to create a `Category` object.
  factory Category.fromJson(Map<String, dynamic> data) => Category(
    id: data["id"],
    name: data["name"],
    icon: IconData(data["icon"], fontFamily: 'MaterialIcons'),
    color: Color(data["color"]),
    budget: data["budget"] ?? 0,
    expense: data["expense"] ?? 0,
  );

  /// The `toJson` function converts object properties to a map with string keys and dynamic values.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon.codePoint,
    "color": color.value,
    "budget": budget,
  };
}