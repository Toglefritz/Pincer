import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The [ThemeData] when the host device is using a light brightness setting.
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFE86D33),
  primaryColorDark: const Color(0xFF23201E),
  primaryColorLight: const Color(0xFFFEF4E3),
  scaffoldBackgroundColor: const Color(0xFFE8D7C5),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontFamily: GoogleFonts.robotoSerif().fontFamily,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontFamily: GoogleFonts.robotoSerif().fontFamily,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      fontFamily: GoogleFonts.robotoSerif().fontFamily,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontFamily: GoogleFonts.robotoSerif().fontFamily,
    ),
    headlineMedium: TextStyle(
      fontFamily: GoogleFonts.robotoSerif().fontFamily,
      fontSize: 32,
    ),
    headlineLarge: TextStyle(
      fontFamily: GoogleFonts.robotoMono().fontFamily,
      fontSize: 64,
    ),
    bodySmall: TextStyle(
      fontFamily: GoogleFonts.robotoMono().fontFamily,
    ),
    bodyMedium: TextStyle(
      fontFamily: GoogleFonts.robotoMono().fontFamily,
    ),
    bodyLarge: TextStyle(
      fontFamily: GoogleFonts.robotoMono().fontFamily,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFE8D7C5),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF23201E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF23201E),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);
