import 'package:dynamic_color/dynamic_color.dart';
import 'package:fintracker/screens/main.screen.dart';
import 'package:fintracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';

class App extends StatelessWidget {
  const App({super.key});
  ThemeData _buildTheme({required Brightness brightness, Color? color}){
    ThemeData baseTheme = ThemeData(
        brightness: brightness,
      colorSchemeSeed: color ?? ThemeColors.primary,
      useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith((Set<MaterialState> states){
            TextStyle style =  TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12, letterSpacing: -0.3,
                fontFamily: GoogleFonts.karla().fontFamily,
            );
            if(states.contains(MaterialState.selected)){
              style = style.merge( const TextStyle(fontWeight: FontWeight.w600));
            }
            return style;
          }),
        )
    );

    return baseTheme.copyWith(
       textTheme: GoogleFonts.karlaTextTheme(baseTheme.textTheme),
    );
  }
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode?  Brightness.light: Brightness.dark
    ));

    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return MaterialApp(
            title: 'Fintracker',
            theme: _buildTheme(brightness: Brightness.light, color: lightDynamic?.primary),
            darkTheme: _buildTheme(brightness: Brightness.dark,  color: darkDynamic?.primary),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
            localizationsDelegates: const [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              MonthYearPickerLocalizations.delegate,
            ],
          );
        });
  }
}