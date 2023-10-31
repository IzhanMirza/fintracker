import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension BuildContextEntension<T> on BuildContext {
  ThemeData get theme => Theme.of(this);
  String? get monoFontFamily => GoogleFonts.jetBrainsMono().fontFamily;
  LinearGradient get gradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: const [0.0, 1],
    colors: <Color>[
      Theme.of(this).colorScheme.primary.withAlpha(50),
      Colors.transparent,
    ],
  );
}