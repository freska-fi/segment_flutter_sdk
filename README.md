# segment_flutter_sdk

[![pub package](https://img.shields.io/pub/v/segment_flutter_sdk.svg)](https://pub.dartlang.org/packages/segment_flutter_sdk)

A Flutter plugin that allows sending analytics events to https://segment.com

## Installation

Just add the dependency on your pubspec.yaml file

## How to use it?

You need to initialize Segment tracker at application startup.

```
Future<void> main() async {
  final segmentTracker = await FlutterSegmentSdk.init(writeKey: "YOUR WRITE KEY HERE", logLevel: LogLevel.VERBOSE);
  runApp(MyApp(segmentTracker));
}
```

Note: There are other parameters available that allows you to customize how Segment SDK works. These are all the init method allowed parameters, being `writeKey` the only required one.

```
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
  })
```

### Track a screen

You can log screens and add custom properties to the screen log event.

```
Future<void> trackScreen({@required String name, Map<String, dynamic> properties})
```

### Track event

You can also track events, api is similar as the one used for screens.

```
Future<void> trackEvent({@required String name, Map<String, dynamic> properties})
```

### Identify a user

Segment allows you to identify customers, this SDK does so by using this method:

```
Future<void> identify({@required String userId})
```

## Example

Checking example app will help you understanding how to initialise and use the SDK. 
