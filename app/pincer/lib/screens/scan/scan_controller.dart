import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_splendid_ble/flutter_splendid_ble.dart';
import 'package:flutter_splendid_ble/models/ble_device.dart';
import 'package:flutter_splendid_ble/models/exceptions/bluetooth_scan_exception.dart';
import 'package:flutter_splendid_ble/models/scan_filter.dart';
import 'package:pincer/screens/scan/scan_route.dart';
import 'package:pincer/screens/scan/scan_view.dart';

/// A controller for the [ScanRoute] that manages the state and owns all business logic.
class ScanController extends State<ScanRoute> {
  /// A [FlutterBle] instance used for Bluetooth operations conducted by this route.
  final FlutterSplendidBle _ble = FlutterSplendidBle();

  /// Determines if a scan is currently in progress.
  bool _scanInProgress = false;

  bool get scanInProgress => _scanInProgress;

  /// A [StreamSubscription] for the Bluetooth scanning process.
  StreamSubscription<BleDevice>? _scanStream;

  /// A list of [BleDevice]s discovered by the Bluetooth scan.
  List<BleDevice> discoveredDevices = [];

  /// The index of the [discoveredDevices] to display in the [ScanView].
  int currentIndex = 0;

  @override
  void initState() {
    // Start the scan as soon as the screen loads
    _startBluetoothScan();

    super.initState();
  }

  /// Starts a scan for nearby Bluetooth devices and adds a listener to the stream of devices detected by the scan.
  ///
  /// The scan is handled by the *flutter_ble* plugin. Regardless of operating system, the scan works by providing a
  /// callback function (in this case [_onDeviceDetected]) that is called whenever a device is detected by the scan.
  /// The [startScan] stream delivers an instance of [BleDevice] to the callback which contains information about
  /// the Bluetooth device.
  ///
  /// In order to only return Pincer robot arm BLE devices, the scan is filtered by the UUID of the primary service
  /// used by all Pincer robot arms.
  void _startBluetoothScan() {
    // Create the scan filter based on the UUID of Pincer robot arms
    ScanFilter scanFilter = ScanFilter(
      serviceUuids: ['b19cdadc-434f-42e2-9478-3bbd98234567'],
    );

    _scanStream = _ble.startScan(filters: [scanFilter]).listen(
      (device) => _onDeviceDetected(device),
      onError: (error) {
        // Handle the error here
        _handleScanError(error);
        return;
      },
    );

    setState(() {
      _scanInProgress = true;
    });
  }

  /// Handles errors returned on the [_scanStream].
  void _handleScanError(error) {
    // Create the SnackBar with the error message
    final snackBar = SnackBar(
      content: const Text('Error scanning for Pincer devices'),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          // If you need to do anything when the user dismisses the SnackBar
        },
      ),
    );

    // Show the SnackBar using the ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// A callback used each time a new device is discovered by the Bluetooth scan.
  void _onDeviceDetected(BleDevice device) {
    debugPrint('Discovered Pincer device, ${device.name}');

    // Add the newly discovered device to the list only if it not already in the list
    if (discoveredDevices.where((discoveredDevice) => discoveredDevice.address == device.address).isEmpty) {
      setState(() {
        discoveredDevices.add(device);
        discoveredDevices.add(device);
        discoveredDevices.add(device);
        discoveredDevices.add(device);
        discoveredDevices.add(device);
        discoveredDevices.add(device);
        discoveredDevices.add(device);
        discoveredDevices.add(device);
      });
    }
  }

  /// Handles taps on the action button in the [AppBar].
  ///
  /// This button is used to start or stop the Bluetooth scan. If a scan is in progress, as determined by the
  /// [_scanInProgress] boolean value, the function stops the scan. If, on the other hand, there is not a scan
  /// in progress, a scan is started.
  void onActionButtonPressed() {
    if (_scanInProgress) {
      _ble.stopScan();
      _scanStream?.cancel();

      setState(() {
        _scanInProgress = false;
      });
    } else {
      setState(() {
        discoveredDevices.clear();
      });

      _startBluetoothScan();
    }
  }

  /// Handles taps on a scan result.
  void onResultTap(BleDevice device) {
    try {
      _ble.stopScan();
    } on BluetoothScanException catch (e) {
      // Handle the exception, possibly by showing an error message to the user.
      _showErrorMessage(e.message);
      return;
    }

    _scanStream?.cancel();

    // TODO save connection info

    // TODO navigate to robot control screen
  }

  /// Displays an error message to the user.
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) => ScanView(this);

  @override
  void dispose() {
    _scanStream?.cancel();

    super.dispose();
  }

  void onResultsPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
