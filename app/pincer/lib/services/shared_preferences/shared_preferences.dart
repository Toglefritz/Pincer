import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_splendid_ble/models/ble_device.dart';
import 'package:pincer/devices/pincer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contains fields and methods used to store and retrieve information from [SharedPreferencesService].
class SharedPreferencesService {
  /// The [pincerDevices] key is used to store information about Pincer robot arms that have been connected via
  /// Bluetooth to the app. The following format is used to store information about the Pincer robot arms:
  ///
  ///   [
  ///     {
  ///       "address": "<BLE device address>",
  ///       "name": "<robot name>",
  ///     }
  ///   [
  ///
  ///   Where the "address" field stores the BLE address of the Pincer robot arm, which is used to re-connect
  ///   to the arm in the future. Note that this address will be the Bluetooth MAC address on Android devices but
  ///   on iOS device will be a unique identifier that is not the same across different iOS devices, even with the
  ///   same Pincer robot arm.
  ///
  ///   The "name" parameter is used to store the name assigned to the user for the Pincer robot arm. If the user has
  ///   not set a custom name for the robot arm, the robot's unique identifier, comprised of the last six digits of the
  ///   controllers MAC address, is used by default.
  static const String pincerDevices = 'pincer_devices';

  /// Saves information about the selected Pincer robot arm, or specifically the [BleDevice] representing the
  /// controller inside the robot arm, to [SharedPreferences].
  static Future<void> saveDeviceInfo(BleDevice device) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get the existing contents of the saved device info from SharedPreferences
      List<Pincer> savedDeviceInfo = await getSavedDeviceInfo();

      // Create the JSON object used to store information about the selected device
      Pincer newDevice = Pincer.fromBleDevice(device);

      savedDeviceInfo.add(newDevice);

      // Convert the JSON object to a string.
      String deviceInfoStr = json.encode(savedDeviceInfo);

      // Save the device info string to local storage
      prefs.setString(SharedPreferencesService.pincerDevices, deviceInfoStr);

      debugPrint('Saved device info: $deviceInfoStr');
    } catch (e) {
      debugPrint('Failed to save device info with exception, $e');

      // TODO show error SnackBar
    }
  }

  /// Retrieves information about previously connected Pincer robot arms from [SharedPreferences]. This function
  /// returns a `List<Pincer>` by converting the JSON content from [SharedPreferences] into a `List<Pincer>`.
  static Future<List<Pincer>> getSavedDeviceInfo() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Read the device info string to local storage
      String? deviceInfoStr = prefs.getString(SharedPreferencesService.pincerDevices);

      // If no device info exists in SharedPreferences
      if (deviceInfoStr == null) {
        debugPrint('No device info saved');
        return [];
      } else {
        // Convert the JSON object to a string.
        List<dynamic> deviceInfo = json.decode(deviceInfoStr);

        debugPrint('Retrieved device info: $deviceInfoStr');

        // Convert the JSON list obtained from SharedPreferences to a list of Pincer objects
        List<Pincer> pincerList = [];
        for (Map<String, dynamic> element in deviceInfo) {
          pincerList.add(Pincer.fromJson(element));
        }

        return pincerList;
      }
    } catch (e) {
      debugPrint('Failed to get saved device information with exception, $e');

      return [];
    }
  }
}
