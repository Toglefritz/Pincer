import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pincer/theme/insets.dart';

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
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.pincer,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).primaryColorDark,
              ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                top: Insets.extraExtraLarge,
              ),
              sliver: SliverToBoxAdapter(
                child: Image.asset(
                  'assets/pincer_assembly_isometric.png',
                  height: 250,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                top: Insets.medium,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  AppLocalizations.of(context)!.noRobotArmsMessage,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Insets.extraExtraLarge,
                      vertical: Insets.extraLarge,
                    ),
                    child: ElevatedButton(
                      onPressed: state.onAddPressed,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Insets.medium,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.connect,
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
          ],
        ),
      ),
    );
  }
}
