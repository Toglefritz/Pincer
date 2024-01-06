import 'package:flutter/material.dart';

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
    return const Scaffold(
      body: Center(),
    );
  }
}
