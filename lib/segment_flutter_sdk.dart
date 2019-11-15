import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum LogLevel { NONE, INFO, DEBUG, VERBOSE }

class FlutterSegmentSdk {
  static FlutterSegmentSdk _instance;

  /// Might be null if still not initialised, ensure init is call on application initialisation
  factory FlutterSegmentSdk() => _instance;

  final MethodChannel _channel;

  const FlutterSegmentSdk._(this._channel);

  static Future<FlutterSegmentSdk> init({
    @required String writeKey,
    bool collectDeviceId,
    int flushQueueSize,
    String tag,
    LogLevel logLevel,
    bool trackApplicationLifecycleEvents,
    bool recordScreenViews,
    bool trackAttributionInformation,
    bool useFirebaseAnalytics,
  }) async {
    if (_instance != null) {
      throw StateError("FlutterSegmentSdk already initialised");
    }
    if (writeKey == null || writeKey.isEmpty) {
      throw ArgumentError.value(
          writeKey, "writeKey", "WriteKey parameter is required");
    }
    final channel =
        const MethodChannel("net.freska.fluttersegmentsdk/segment_flutter_sdk");
    final arguments = <String, dynamic>{
      "writeKey": writeKey,
    };
    // Add rest of arguments if they do exist
    if (collectDeviceId != null) {
      arguments["collectDeviceId"] = collectDeviceId;
    }
    if (flushQueueSize != null) {
      arguments["flushQueueSize"] = flushQueueSize;
    }
    if (tag != null) {
      arguments["tag"] = tag;
    }
    if (logLevel != null) {
      arguments["logLevel"] = logLevel.toString().split('.')[1];
    }
    if (trackApplicationLifecycleEvents != null) {
      arguments["trackApplicationLifecycleEvents"] =
          trackApplicationLifecycleEvents;
    }
    if (recordScreenViews != null) {
      arguments["recordScreenViews"] = recordScreenViews;
    }
    if (trackAttributionInformation != null) {
      arguments["trackAttributionInformation"] = trackAttributionInformation;
    }
    if (useFirebaseAnalytics != null) {
      arguments["firebaseAnalytics"] = useFirebaseAnalytics;
    }

    return await channel.invokeMethod("init", arguments).then((_) {
      _instance = FlutterSegmentSdk._(channel);
      return _instance;
    });
  }

  /// Logs a screen in segment with the given [name] and extra [properties].
  Future<void> trackScreen(
      {@required String name, Map<String, dynamic> properties}) async {
    if (name == null || name.isEmpty) {
      throw ArgumentError.value(name, "name", "Screen name is required");
    }

    await _channel.invokeMethod("trackScreen", <String, dynamic>{
      "name": name,
      "properties": properties,
    });
  }

  /// Logs a event in segment with the given [name] and extra [properties].
  Future<void> trackEvent(
      {@required String name, Map<String, dynamic> properties}) async {
    if (name == null || name.isEmpty) {
      throw ArgumentError.value(name, "name", "Event name is required");
    }

    await _channel.invokeMethod("trackEvent", <String, dynamic>{
      "name": name,
      "properties": properties,
    });
  }

  /// Identifies the user in Segment using given user [userId]. [userId] can be null to clear the identity of the user
  /// for example, when login out.
  /// [traits] are optional, used to provide valuable information to identify users.
  /// Visit [segment documentation](https://segment.com/docs/spec/common/) for checking common identify properties
  Future<void> identify(
      {@required String userId, Map<String, dynamic> traits}) async {
    await _channel.invokeMethod("identify", <String, dynamic>{
      "userId": userId,
      "traits": traits ?? {},
    });
  }

  /// Enabled Segment SDK to continue sending analytics events
  Future<void> enable() async => await _channel.invokeMethod("enable");

  /// Disables Segment SDK to stop sending analytics events
  Future<void> disable() async => await _channel.invokeMethod("disable");

  /// Resets Segment SDK
  Future<void> reset() async => await _channel.invokeMethod("reset");
}
