import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home.dart';
import 'home_view_loading.dart';

/// Controller for the [HomeRoute] that contains all of the business logic used by this route.
class HomeController extends State<HomeRoute> {
  bool? _permissionsGranted;

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
    bool locationPermissionsGranted = await _requestLocationPermission();
    bool bluetoothPermissionsGranted = await _requestBluetoothPermissions();

    setState(() {
      _permissionsGranted = locationPermissionsGranted && bluetoothPermissionsGranted;
    });

    // TODO get saved Pincer connections
  }

  /// Requests location permission.
  ///
  /// Location permission is required for BLE communication in many platforms, including Android and iOS, due to
  /// the need for location data to scan for BLE devices.
  Future<bool> _requestLocationPermission() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  /// Requests Bluetooth permissions.
  ///
  /// These permissions are essential for establishing BLE connections and communicating with the Pincer robot arm.
  Future<bool> _requestBluetoothPermissions() async {
    if (await Permission.bluetooth.request().isGranted && await Permission.bluetoothConnect.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  // TODO show different views based on _permissionsGranted value
  @override
  Widget build(BuildContext context) => HomeViewLoading(this);
}
