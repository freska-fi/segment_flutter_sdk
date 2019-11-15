import Flutter
import UIKit
import Analytics

public class SwiftSegmentFlutterSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "net.freska.fluttersegmentsdk/segment_flutter_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftSegmentFlutterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "init":
      handleInitAnalytics(call: call, result: result)
    case "identify":
      handleIdentify(call: call, result: result)
    case "trackScreen":
      handleTrackScreen(call: call, result: result)
    case "trackEvent":
      handleTrackEvent(call: call, result: result)
    case "enable":
      handleEnable(result: result)
    case "disable":
      handleDisable(result: result)
    case "reset":
      handleReset(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handleInitAnalytics(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "ERROR", message: "Arguments are missing", details: nil))
      return
    }
    guard let writeKey = args["writeKey"] as? String else {
      result(FlutterError(code: "ERROR", message: "WriteKey parameter is missing", details: nil))
      return
    }
    let config = SEGAnalyticsConfiguration(writeKey: writeKey)
    // add optional arguments if provided as arguments
    if let flushQueueSize = args["flushQueueSize"] as? NSNumber {
      config.flushAt = flushQueueSize.uintValue
    }
    if let trackApplicationLifecycleEvents = args["trackApplicationLifecycleEvents"] as? Bool {
      config.trackApplicationLifecycleEvents = trackApplicationLifecycleEvents
    }
    if let recordScreenViews = args["recordScreenViews"] as? Bool {
      config.recordScreenViews = recordScreenViews
    }
    if let trackAttributionInformation = args["trackAttributionInformation"] as? Bool {
      config.trackAttributionData = trackAttributionInformation
    }
    SEGAnalytics.setup(with: config)

    if let logLevel = args["logLevel"] as? String {
      SEGAnalytics.debug(logLevel != "NONE")
    }

    result(nil)
  }

  private func handleIdentify(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "ERROR", message: "Arguments are missing", details: nil))
      return
    }
    
    if let userId = args["userId"] as? String {
      SEGAnalytics.shared()?.identify(userId, traits: args["traits"] as? [String: Any])
    } else {
      SEGAnalytics.shared()?.reset()
    }

    result(nil)
  }

  private func handleTrackEvent(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "ERROR", message: "Arguments are missing", details: nil))
      return
    }
    guard let name = args["name"] as? String else {
      result(FlutterError(code: "ERROR", message: "Event name is compulsory", details: nil))
      return
    }
    if let properties = args["properties"] as? [String: Any] {
      SEGAnalytics.shared()?.track(name, properties: properties)
    } else {
      SEGAnalytics.shared()?.track(name)
    }
    result(nil)
  }

  private func handleTrackScreen(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "ERROR", message: "Arguments are missing", details: nil))
      return
    }
    guard let name = args["name"] as? String else {
      result(FlutterError(code: "ERROR", message: "Screen name is compulsory", details: nil))
      return
    }
    if let properties = args["properties"] as? [String: Any] {
      SEGAnalytics.shared()?.screen(name, properties: properties)
    } else {
      SEGAnalytics.shared()?.screen(name)
    }
    result(nil)
  }
  
  private func handleEnable(result: @escaping FlutterResult) {
    SEGAnalytics.shared()?.enable()
    result(nil)
  }
  
  private func handleDisable(result: @escaping FlutterResult) {
    SEGAnalytics.shared()?.disable()
    result(nil)
  }

  private func handleReset(result: @escaping FlutterResult) {
    SEGAnalytics.shared()?.reset()
    result(nil)
  }
}
