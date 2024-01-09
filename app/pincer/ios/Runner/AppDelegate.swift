import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Setting up the method channel.
        let controller = window?.rootViewController as! FlutterViewController
        let iconChannel = FlutterMethodChannel(name: "com.splendidendeavors.pincer/iconChanger",
                                               binaryMessenger: controller.binaryMessenger)
        
        iconChannel.setMethodCallHandler { [weak self] (call, result) in
            // Handling the 'setAlternateIcon' method.
            if call.method == "setAlternateIcon" {
                self?.setAlternateIcon(call: call, result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /// Sets an alternate icon for the application.
    ///
    /// This function is called from the Flutter side through a Method Channel. It allows the Flutter
    /// application to request the change of the app icon on an iOS device. The function utilizes
    /// the `setAlternateIconName` method of `UIApplication` to change the app icon.
    ///
    /// The alternate icons must be pre-defined in the app's `Info.plist` under the `CFBundleIcons` key.
    /// Each alternate icon is identified by a unique key, which is used to refer to the icon in the
    /// `Info.plist` and should be passed to this function to change the icon.
    ///
    /// Parameters:
    /// - call: The `FlutterMethodCall` object containing the method call from Flutter.
    ///   It should contain a dictionary with the key 'iconName', where the value is the
    ///   name of the icon to be set. If the value is `nil` or not provided, the default
    ///   app icon will be used.
    /// - result: The `FlutterResult` callback to return the result back to Flutter. This
    ///   callback is used to send success or error information back to the Flutter side.
    ///
    /// The method handles setting the icon asynchronously. If successful, it returns `nil` to Flutter;
    /// if there is an error, it returns a `FlutterError` with appropriate error details.
    ///
    /// Usage:
    /// To change the app icon to an alternate icon named 'holidayIcon', the Flutter app would call
    /// `IconChanger.setAlternateIcon('holidayIcon')`. To revert to the default icon, `null` is passed.
    ///
    /// Note:
    /// - Only available on iOS 10.3 and later.
    /// - Changing the app icon is a potentially slow operation that may momentarily display an alert
    ///   to the user.
    private func setAlternateIcon(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any?],
              let iconNameOptional = args["iconName"] else {
            result(FlutterError(code: "INVALID_ARGUMENTS",
                                message: "Argument format is incorrect",
                                details: nil))
            return
        }
        
        // Flatten the double optional.
        let iconName = iconNameOptional as? String
        
        // Setting the alternate icon.
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                result(FlutterError(code: "UNABLE_TO_CHANGE_ICON",
                                    message: "Failed to change app icon",
                                    details: error.localizedDescription))
            } else {
                result(nil)
            }
        }
    }
}
