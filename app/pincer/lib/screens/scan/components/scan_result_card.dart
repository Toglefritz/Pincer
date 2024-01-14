import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_splendid_ble/models/ble_device.dart';
import 'package:pincer/theme/insets.dart';

/// Presents information about a Pincer device discovered by the Bluetooth scanning process.
class ScanResultCard extends StatelessWidget {
  /// The index of the card in the list of devices discovered by the Bluetooth scan.
  final int index;

  /// The [BleDevice] discovered by the Bluetooth scanning process. This object contains information about the
  /// device that will be displayed by this widget.
  final BleDevice device;

  const ScanResultCard({
    super.key,
    required this.device,
    required this.index,
  });

  /// Returns the path to use for an image on the card. The cards in the list cycle through three images in the
  /// following pattern: pincer_left, pincer_ne_iso, pincer_top, and then repeating.
  String _selectImageAsset() {
    // Define your image assets paths here
    List<String> imageAssets = [
      'assets/pincer_left.png',
      'assets/pincer_ne_iso.png',
      'assets/pincer_top.png',
    ];

    // Select the image asset based on the repeating pattern
    return imageAssets[index % 3];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorDark,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: Insets.large,
            ),
            child: Image.asset(
              _selectImageAsset(),
              height: 300,
            ),
          ),
          Text(
            device.name?.split(' ')[0] ?? AppLocalizations.of(context)!.pincer,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).primaryColorLight,
                ),
          ),
          Text(
            device.name?.split(' ')[1] ?? AppLocalizations.of(context)!.pincer,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).primaryColorLight,
                ),
          ),
        ],
      ),
    );
  }
}
