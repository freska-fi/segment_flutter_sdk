import Flutter
import UIKit

public class SwiftSegmentFlutterSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "net.freska.fluttersegmentsdk/segment_flutter_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftSegmentFlutterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "init":
        NSLog("init called, Missing iOS implementation")
        result(nil)
    case "trackScreen":
        NSLog("trackScreen called, Missing iOS implementation")
        result(nil)
    case "trackEvent":
        NSLog("trackEvent called, Missing iOS implementation")
        result(nil)
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
