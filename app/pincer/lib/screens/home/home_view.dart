import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_controller.dart';

/// View for the [HomeRoute]. The view is purely declarative and references the [HomeController] for all business logic.
///
/// The [HomeView] view is displayed after permissions and the status of the Bluetooth adapter have been checked. If
/// there are any existing connections to any Pincer robot arms, they will be listed in this view. If no connections
/// exist, the app will display a message indicating such. This view also contains a button that can be used to
/// start the connection process for a Pincer robot arm.
class HomeView extends StatelessWidget {
  /// A controller for this view.
  final HomeController state;

  const HomeView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.pincer,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/pincer_assembly_isometric.png',
                height: 161.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
