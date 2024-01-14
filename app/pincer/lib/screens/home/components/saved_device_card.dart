import 'package:flutter/material.dart';

import 'package:pincer/theme/insets.dart';
import '../../../devices/pincer.dart';

/// Presents information about a Pincer device discovered by the Bluetooth scanning process.
class SavedDeviceCard extends StatelessWidget {
  /// The index of the card in the list of devices discovered by the Bluetooth scan.
  final int index;

  /// The [Pincer] object constructed using information stored in local storage via [SharedPreferences].
  final Pincer pincer;

  /// A function called when the [ScanResultCard] is tapped.
  final VoidCallback onTap;

  const SavedDeviceCard({
    super.key,
    required this.index,
    required this.pincer,
    required this.onTap,
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: Insets.medium,
          horizontal: Insets.extraExtraLarge,
        ),
        color: Theme.of(context).primaryColorDark,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(
                Insets.medium,
              ),
              child: Image.asset(
                _selectImageAsset(),
                width: 150,
              ),
            ),
            Text(
              pincer.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).primaryColorLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
