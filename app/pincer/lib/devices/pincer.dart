import 'package:flutter_splendid_ble/models/ble_device.dart';

/// Represents a Pincer robot arm.
///
/// Pincer is a miniature robot arm project designed for educational purposes in robotics. It offers a hands-on
/// experience in understanding and building robotic arms without > the risk of those hands getting smashed. This
/// class represents the Pincer robot arm, and specifically the information needed to connect to a control a Pincer
/// robot arm.
class Pincer {
  /// The name of the Pincer robot arm. By default, the name of the arm consists of the word "Pincer" and the last
  /// six digits of the MAC address of the controller inside the robot arm. For example, "Pincer 88064". However, the
  /// user can assign a custom name to their Pincer robot arm once it is connected via the app.
  final String name;

  /// The Bluetooth Low Energy (BLE) device address of the Pincer robot arm's controller. On Android devices, this
  /// will be the Bluetooth MAC address. On iOS devices, this is a unique identifier for the combination of the Pincer
  /// robot arm and the specific iOS device to which it is connected. In other words, the same Pincer robot arm will
  /// have different BLE identifiers on different iOS devices.
  final String address;

  Pincer({
    required this.name,
    required this.address,
  });

  /// Returns a [Pincer] object from the provided JSON content.
  factory Pincer.fromJson(Map<String, dynamic> json) {
    return Pincer(
      name: json['name'],
      address: json['address'],
    );
  }

  /// Returns a [Pincer] object from the provided [BleDevice]. This constructor is used as part of the BLE scanning
  /// process to save information about Pincer robot arms selected from the list of discovered devices.
  factory Pincer.fromBleDevice(BleDevice device) {
    return Pincer(
      name: device.name ?? 'Pincer',
      address: device.address,
    );
  }
}
