import 'package:flutter/material.dart';

import 'package:pincer/screens/home/home.dart';

/// The [PincerApp] widget contains the [MaterialApp] widget that provides theming, navigation, layout, and other
/// resources for the rest of the app.
class PincerApp extends StatelessWidget {
  const PincerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        useMaterial3: true,
      ),
      home: const HomeRoute(),
    );
  }
}