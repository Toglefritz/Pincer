import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_controller.dart';

/// View for the [HomeRoute]. The view is purely declarative and references the [HomeController] for all business logic.
///
/// The [HomeViewLoading] view is displayed while the initialization tasks handled by the [HomeRoute] (or more
/// specifically the [HomeController]) are performed.
class HomeViewLoading extends StatelessWidget {
  /// A controller for this view.
  final HomeController state;

  const HomeViewLoading(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 200,
              height: 161.5,
              child: RiveAnimation.asset(
                'assets/pincer_loading_indicator.riv',
              ),
            ),
            Text(
              AppLocalizations.of(context)!.loading,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
