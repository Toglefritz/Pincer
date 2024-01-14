import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pincer/screens/scan/scan_controller.dart';
import 'package:pincer/theme/insets.dart';

/// View for the [ScanRoute]. The view is purely declarative and references the [ScanController] for all business logic.
///
/// The [ScanViewError] view is displayed when a timeout is reached, before which no devices were detected by the
/// Bluetooth scan.
///
/// The view consists of an image with a flashing warning icon overlay on top. The icon flashes back and forth between
/// a visible and invisible state.
class ScanViewError extends StatelessWidget {
  /// A controller for this view.
  final ScanController state;

  const ScanViewError(this.state, {Key? key}) : super(key: key);

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
                      'assets/pincer_back.png',
                      height: 250,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: state.isErrorIconVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.question_mark_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 161.5,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: Insets.paddingLarge,
                child: Text(
                  AppLocalizations.of(context)!.noDevicesFound,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: Insets.extraExtraLarge,
                  vertical: Insets.extraLarge,
                ),
                child: ElevatedButton(
                  onPressed: state.restartScan,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Insets.medium,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.tryAgain,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
