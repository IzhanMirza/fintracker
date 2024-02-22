import 'package:flutter/material.dart';

/// The `ColorHelper` class in Dart provides static methods to darken and lighten colors by adjusting
/// their lightness values within a specified range.
class ColorHelper{
  /// The `darken` function takes a Color and an optional amount parameter to return a darker version of
  /// the color based on the specified amount.
  /// 
  /// Args:
  ///   color (Color): The `color` parameter represents the original color that you want to darken.
  ///   amount (double): The `amount` parameter is a double value that represents the amount by which
  /// the color should be darkened. It should be a value between 0 and 1, where 0 means no darkening
  /// (the color remains the same) and 1 means fully darkened (the color becomes black. Defaults to .1
  /// 
  /// Returns:
  ///   The `darken` function returns a new color that is a darker version of the input color by the
  /// specified amount.
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  /// The `lighten` function takes a Color and an optional amount parameter to lighten the color by
  /// adjusting its lightness value in the HSL color space.
  /// 
  /// Args:
  ///   color (Color): The `color` parameter represents the original color that you want to lighten.
  ///   amount (double): The `amount` parameter is a double value that represents the amount by which
  /// the color should be lightened. It has a default value of 0.1 and should be between 0 and 1,
  /// inclusive. This parameter controls how much lighter the resulting color will be compared to the
  /// original color. Defaults to .1
  /// 
  /// Returns:
  ///   The `lighten` function returns a new color that is a lighter version of the input color by the
  /// specified amount.
  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}