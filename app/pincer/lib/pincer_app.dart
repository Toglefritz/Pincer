import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:pincer/screens/home/home.dart';
import 'package:pincer/services/icon_changer/icon_changer.dart';
import 'package:pincer/theme/dark_theme.dart';
import 'package:pincer/theme/light_theme.dart';

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
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomeRoute(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
