import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pincer/screens/home/home.dart';

/// The [PincerApp] widget contains the [MaterialApp] widget that provides theming, navigation, layout, and other
/// resources for the rest of the app.
class PincerApp extends StatelessWidget {
  const PincerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pincer',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
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
          ),
          headlineLarge: TextStyle(
            fontFamily: GoogleFonts.robotoSerif().fontFamily,
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
      ),
      darkTheme: ThemeData(
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
            fontFamily: GoogleFonts.robotoSerif().fontFamily,
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
      ),
      home: const HomeRoute(),
    );
  }
}
