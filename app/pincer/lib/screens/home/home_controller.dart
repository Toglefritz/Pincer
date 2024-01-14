import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pincer/devices/pincer.dart';
import 'package:pincer/screens/scan/scan_route.dart';
import 'package:pincer/services/shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'home_view.dart';
import 'home_view_error.dart';
import 'home_view_loading.dart';

/// Controller for the [HomeRoute] that contains all of the business logic used by this route.
class HomeController extends State<HomeRoute> {
  /// Determines if Bluetooth permissions have been granted and the status of the Bluetooth adapter has been
  /// checked. A value of null indicates that these two operations have not yet been completed. A value of true
  /// indicates that both Bluetooth permissions have been granted and the Bluetooth adapter is enabled. A value
  /// of false indicates that either Bluetooth permissions were denied or the Bluetooth adapter is disabled.
  bool? _permissionsGranted;

  /// When this route is in an error state because either Bluetooth permissions were denied or because the
  /// Bluetooth adapter is disabled, among the UI elements displayed is a flashing icon. This boolean
  /// determines if the icon is visible.
  bool isErrorIconVisible = true;

  /// When this route is in an error state because either Bluetooth permissions were denied or because the
  /// Bluetooth adapter is disabled, among the UI elements displayed is a flashing icon. This [Timer] controls the
  /// flashing of this icon.
  Timer? _timer;

  /// A list of devices that were previously connected to the app. Information about these devices is retrieved
  /// from [SharedPreferences].
  // TODO convert to use custom class
  List<Pincer>? devices;

  @override
  void initState() {
    super.initState();
    _checkBluetoothAdapterAndRequestPermissions();
  }

  /// Checks the Bluetooth adapter status and requests necessary permissions. If both the adapter is enabled and
  /// permissions are granted, sets the value of [_permissionsGranted] to true and the app will continue to the next
  /// step. If either the adapter is turned off or Bluetooth permissions were denied, [_permissionsGranted] is set to
  /// false and an error page is displayed.
  Future<void> _checkBluetoothAdapterAndRequestPermissions() async {
    bool bluetoothPermissionsGranted = await _requestBluetoothPermissions();

    setState(() {
      _permissionsGranted = bluetoothPermissionsGranted;
    });

    if (_permissionsGranted == false) {
      // Start the timer for the flashing icon effect
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          isErrorIconVisible = !isErrorIconVisible;
        });
      });
    } else if (_permissionsGranted == true) {
      getSavedDevices();
    }
  }

  /// Retrieves a list of saved devices from [SharedPreferences].
  Future<void> getSavedDevices() async {
    List<Pincer> savedDevices = await SharedPreferencesService.getSavedDeviceInfo();

    setState(() {
      devices = savedDevices;
    });
  }

  /// Requests Bluetooth permissions.
  ///
  /// These permissions are essential for establishing BLE connections and communicating with the Pincer robot arm.
  Future<bool> _requestBluetoothPermissions() async {
    if (await Permission.bluetooth.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  /// Handles taps on the button used to start the flow to connect to a Pincer robot arm.
  void onAddPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanRoute(),
      ),
    );
  }

  /// Handles taps on the saved device cards, which navigates to the control route.
  void onSavedDeviceTap(Pincer pincer) {
    // TODO navigate to control route
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionsGranted == null || devices == null) {
      return HomeViewLoading(this);
    } else if (_permissionsGranted == true) {
      return HomeView(this);
    } else {
      return HomeViewError(this);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
