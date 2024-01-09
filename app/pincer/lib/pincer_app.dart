import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pincer/screens/home/home.dart';
import 'package:pincer/services/icon_changer/icon_changer.dart';

/// The [PincerApp] widget contains the [MaterialApp] widget that provides theming, navigation, layout, and other
/// resources for the rest of the app.
class PincerApp extends StatefulWidget {
  const PincerApp({super.key});

  @override
  State<PincerApp> createState() => _PincerAppState();
}

class _PincerAppState extends State<PincerApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // Listen to changes in the brightness setting of the host device.
    WidgetsBinding.instance.addObserver(this);

    // Set the app icon based on the initial brightness setting.
    Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _updateAppIcon(brightness);
  }

  /// Listen to changes in the brightness setting of the host device (light versus dark brightness) and set the
  /// app icon to either the default icon when light brightness is in use or the dark icon when the dark brightness
  /// is in use.
  @override
  void didChangePlatformBrightness() {
    Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _updateAppIcon(brightness);
  }

  /// Updates the app icon based on the provided [Brightness] value. If [Brightness.light] is set, the app will use
  /// its default icon. If [Brightness.dark] is set, an alternate icon will be used.
  void _updateAppIcon(Brightness brightness) {
    if (brightness == Brightness.light) {
      // Use the default icon
      IconChanger.setAlternateIcon(null);
    } else {
      IconChanger.setAlternateIcon('darkIcon');
    }
  }

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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
