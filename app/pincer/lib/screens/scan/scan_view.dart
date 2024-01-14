import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pincer/screens/scan/scan_controller.dart';

import '../components/loading_indicator.dart';
import 'components/scan_result_card.dart';

/// View for the [ScanRoute]. The view is dumb, and purely declarative. References values
/// on the controller and widget.
class ScanView extends StatelessWidget {
  /// A controller for the view containing its business logic.
  final ScanController state;

  const ScanView(this.state, {Key? key}) : super(key: key);

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
        leading: IconButton(
          onPressed: state.onBackPressed,
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: state.onActionButtonPressed,
            icon: Icon(state.scanInProgress ? Icons.stop_outlined : Icons.play_arrow_outlined),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (state.discoveredDevices.isEmpty)
              LoadingIndicator(
                message: AppLocalizations.of(context)!.scanning,
              ),
            if (state.discoveredDevices.isNotEmpty)
              Text(
                AppLocalizations.of(context)!.selectRobot,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            if (state.discoveredDevices.isNotEmpty)
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  heightFactor: 0.6,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.9),
                    onPageChanged: (index) => state.onResultsPageChanged(index),
                    itemCount: state.discoveredDevices.length,
                    itemBuilder: (context, index) {
                      return ScanResultCard(
                        index: index,
                        device: state.discoveredDevices[index],
                        onTap: () => state.onResultTap(state.discoveredDevices[index]),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
