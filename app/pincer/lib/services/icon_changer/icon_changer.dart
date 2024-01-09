import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// The [IconChanger] class provides a bridge to iOS native code to change the app's icon.
///
/// This class utilizes Flutter's Method Channel to communicate with native iOS code. It allows Flutter apps to
/// dynamically change their app icon on iOS devices.
///
/// iOS allows apps to have alternate icons configured in the app's `Info.plist` file. These icons can then be
/// programmatically set at runtime. This feature lets apps provide a personalized or branded experience by changing
/// the icon based on user preferences, events, or promotions.
///
/// The alternate icons must be added to the iOS project and properly registered in the `CFBundleIcons` key of the
/// app's `Info.plist` file. Each icon should have a unique key that the app uses to refer to the icon. This key is
/// what should be passed to the [setAlternateIcon] method of this class.
///
/// Note:
///   - Changing the app icon is an iOS-only feature. Attempting to use this class on platforms other than iOS will
///     result in no operation.
///   - There can be a slight delay when changing the icon, as this is an asynchronous operation.
///   - The default icon cannot be changed and is used when `null` is passed as the icon name.
class IconChanger {
  // MethodChannel is declared with a unique name.
  static const _channel = MethodChannel('com.splendidendeavors.pincer/iconChanger');

  /// Sets the alternate icon for the app.
  ///
  /// [iconName] is the name of the icon to be set. If null, the default icon is used. This method invokes the native
  /// platform method to change the app icon.
  static Future<void> setAlternateIcon(String? iconName) async {
    if (Platform.isIOS) {
      try {
        // Invoking the native method with the icon name.
        await _channel.invokeMethod(
          'setAlternateIcon',
          {'iconName': iconName},
        );
      } on PlatformException catch (e) {
        debugPrint('Failed to set alternate icon: ${e.message}');

        // If the icon fails to change, it will just remain set as the default icon and the app will continue to
        // function so no further action is necessary.
      }
    } else {
      debugPrint('Alternate icons are only available on iOS');

      // No-op
    }
  }
}
