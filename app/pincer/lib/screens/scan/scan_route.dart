import 'package:flutter/material.dart';

import 'package:pincer/screens/scan/scan_controller.dart';
import '../../devices/pincer.dart';

/// Automatically starts a scan for nearby Pincer Bluetooth devices and presents the detected devices in a list.
class ScanRoute extends StatefulWidget {
  const ScanRoute({
    Key? key,
    required this.excludedDevices,
  }) : super(key: key);

  /// A list of [Pincer] devices that are already saved to local storage and should therefore be excluded from the
  /// scan list presented by this route.
  final List<Pincer> excludedDevices;

  @override
  ScanController createState() => ScanController();
}
