import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/loading_indicator.dart';
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
        child: LoadingIndicator(
          message: AppLocalizations.of(context)!.loading,
        ),
      ),
    );
  }
}
