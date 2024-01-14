import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pincer/screens/home/home.dart';
import 'package:pincer/screens/scan/scan_view_error.dart';
import 'package:pincer/services/shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// A [Timer] used to trigger timeout condition of no devices are detected before a timeout duration is reached.
  Timer? _scanTimer;

  /// Determines if the scan timed out without detecting any devices.
  bool _noDevicesDetected = false;

  /// When a timeout is reached before the first device is discovered by the Bluetooth scanning process, this route
  /// will present an error condition. Among the UI elements displayed is a flashing icon. This [Timer] controls the
  /// flashing of this icon.
  Timer? _iconAnimationTimer;

  /// When this route is in an error state because a timeout was reached before the first device was detected by
  /// the Bluetooth scan, among the UI elements displayed is a flashing icon. This boolean determines if the icon is
  /// visible.
  bool isErrorIconVisible = true;

  @override
  void initState() {
    // Start the scan as soon as the screen loads
    _startBluetoothScan();

    // Start a timeout to trigger an error condition if at least one Pincer device is not discovered before the
    // timeout is reached.
    _startScanTimeout();

    super.initState();
  }

  /// Starts a timer for a 4-second timeout used to trigger an error condition if no devices are detected by the
  /// Bluetooth scan before the timeout is reached.
  ///
  /// There are various scenarios in which the Bluetooth scan may fail to detect a Pincer device. In order to avoid
  /// excessive battery drain on the mobile device or a poor user experience caused by a perpetual loading state, a
  /// timeout is used to stop the scan and deliver an error message if no devices are detected before the timeout
  /// expires.
  void _startScanTimeout() {
    _scanTimer = Timer(const Duration(seconds: 4), handleScanTimeout);
  }

  /// Handles the scenario when the scan timer completes. When the timer completes, this function checks if any devices
  /// were discovered. If none were discovered, an error condition is triggered.
  void handleScanTimeout() {
    if (discoveredDevices.isEmpty) {
      debugPrint('No Pincer devices found');

      // Stop the scan
      _scanStream?.cancel();

      _iconAnimationTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          isErrorIconVisible = !isErrorIconVisible;
        });
      });

      setState(() {
        _noDevicesDetected = true;
      });
    }
  }

  /// Handles taps on the back button.
  void onBackPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeRoute(),
      ),
    );
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
    debugPrint('Discovered Pincer device, ${device.name}, with address, ${device.address}');

    // Check if the device should be excluded because it is already saved to the phone.
    if (widget.excludedDevices.where((savedDevice) => savedDevice.address == device.address).isNotEmpty) {
      debugPrint('Ignoring excluded device, ${device.name}');

      return;
    }

    // Add the newly discovered device to the list only if it not already in the list
    if (discoveredDevices.where((discoveredDevice) => discoveredDevice.address == device.address).isEmpty) {
      setState(() {
        discoveredDevices.add(device);
      });
    }
  }

  /// Handles changes in the "Page" used to present a list of devices detected by the Bluetooth scan.
  void onResultsPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
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
  ///
  /// This function performs two tasks when a Pincer robot arm  is selected from the list of devices detected by
  /// the BLE scan:
  ///   1.  Save information about the Pincer device via [SharedPreferences].
  ///   2.  Navigate to the [RobotControlRoute], providing the [Pincer] object corresponding to the selected device.
  Future<void> onResultTap(BleDevice device) async {
    try {
      _ble.stopScan();
    } on BluetoothScanException catch (e) {
      // Handle the exception, possibly by showing an error message to the user.
      _showErrorMessage(e.message);
      return;
    }

    // Stop the scan
    _scanStream?.cancel();

    // Save information about the selected Pincer robot arm
    SharedPreferencesService.saveDeviceInfo(device);

    // TODO navigate to robot control screen
  }

  /// Displays an error message to the user.
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Handles taps on the button used to restart the scan after it times out.
  void restartScan() {
    // Reset the error condition
    setState(() {
      _noDevicesDetected = false;
    });

    // Start a new Bluetooth scan
    _startBluetoothScan();

    // Start a new timeout
    _scanTimer?.cancel();
    _startScanTimeout();
  }

  @override
  Widget build(BuildContext context) {
    if (_noDevicesDetected) {
      return ScanViewError(this);
    } else {
      return ScanView(this);
    }
  }

  @override
  void dispose() {
    _scanStream?.cancel();
    _scanTimer?.cancel();
    _iconAnimationTimer?.cancel();

    super.dispose();
  }
}
