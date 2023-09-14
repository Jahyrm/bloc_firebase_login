import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static ThemeData lightBaseTheme = ThemeData.light();

  static ThemeData lightTheme = lightBaseTheme.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(),
    primaryColorDark: const Color(0xFF0097A7),
    primaryColorLight: const Color(0xFFB2EBF2),
    primaryColor: const Color(0xFF00BCD4),
    colorScheme: const ColorScheme.light(secondary: Color(0xFF009688)),
    scaffoldBackgroundColor: const Color(0xFFE0F2F1),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static ThemeData darkBaseTheme = ThemeData.dark();

  static ThemeData darkTheme = darkBaseTheme.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static ThemeData lightDevTheme = lightTheme.copyWith(
      // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      );

  static ThemeData darkDevTheme = darkTheme.copyWith(
      // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      );
}
