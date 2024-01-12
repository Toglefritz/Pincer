import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pincer/theme/insets.dart';

import 'home_controller.dart';

/// View for the [HomeRoute]. The view is purely declarative and references the [HomeController] for all business logic.
///
/// The [HomeViewError] view is displayed when there is an issue related to Bluetooth permissions or the Bluetooth
/// adapter.
///
/// The view consists of an image with a flashing warning icon overlay on top. The icon flashes back and forth between
/// a visible and invisible state.
class HomeViewError extends StatelessWidget {
  /// A controller for this view.
  final HomeController state;

  const HomeViewError(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.bluetoothError,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: state.isErrorIconVisible ? 0.4 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    child: Image.asset(
                      'assets/pincer_gripper_assembly.png',
                      height: 161.5,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: state.isErrorIconVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.error_outline,
                      color: Color(0xFFE83348),
                      size: 161.5,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: Insets.paddingLarge,
                child: Text(
                  AppLocalizations.of(context)!.checkSettings,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
