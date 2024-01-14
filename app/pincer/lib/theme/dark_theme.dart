import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The [ThemeData] when the host device is using a light brightness setting.
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFE86D33),
  primaryColorLight: const Color(0xFF23201E),
  primaryColorDark: const Color(0xFFE8D7C5),
  scaffoldBackgroundColor: const Color(0xFF23201E),
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
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF23201E),
    titleTextStyle: TextStyle(
      fontFamily: GoogleFonts.robotoSerif().fontFamily,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF23201E),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFE8D7C5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFFE8D7C5),
    shape: RoundedRectangleBorder(
      side: const BorderSide(
        color: Color(0xFFE86D33),
        width: 3.0,
      ),
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);
