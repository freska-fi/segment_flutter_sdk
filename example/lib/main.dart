import 'dart:async';

import 'package:flutter/material.dart';
import 'package:segment_flutter_sdk/segment_flutter_sdk.dart';

Future<void> main() async {
  final segmentTracker = await FlutterSegmentSdk.init(writeKey: "YOUR WRITE KEY HERE", logLevel: LogLevel.VERBOSE);
  runApp(MyApp(segmentTracker));
}

class MyApp extends StatelessWidget {
  final FlutterSegmentSdk _segmentTracker;

  const MyApp(this._segmentTracker);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('FlutterSegmentSdk example app'),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  child: const Text("Test trackScreen without properties"),
                  color: Colors.grey,
                  onPressed: _testTrackScreenWithoutProperties,
                ),
                MaterialButton(
                    child: const Text("Test trackScreen with properties"),
                    color: Colors.grey,
                    onPressed: () => _testTrackScreenWithProperties("key", "value")),
                MaterialButton(
                  child: const Text("Test trackEvent without properties"),
                  color: Colors.grey,
                  onPressed: _testTrackEventWithoutProperties,
                ),
                MaterialButton(
                    child: const Text("Test trackEvent with properties"),
                    color: Colors.grey,
                    onPressed: () => _testTrackEventWithProperties("key", "value")),
                MaterialButton(
                  child: const Text("Test identify with ID"),
                  color: Colors.grey,
                  onPressed: () => _testIdentify('id'),
                ),
                MaterialButton(
                  child: const Text("Test identify with Traits"),
                  color: Colors.grey,
                  onPressed: () => _testIdentify(
                    'id',
                    traits: {
                      "email": "example@example.org",
                      "phone": "+1 12241 12412",
                      "address": {
                        "city": "helsinki",
                      }
                    },
                  ),
                ),
                MaterialButton(
                  child: const Text("Test identify with null ID"),
                  color: Colors.grey,
                  onPressed: () => _testIdentify(null),
                ),
                MaterialButton(
                  child: const Text("Test disable"),
                  color: Colors.grey,
                  onPressed: () => _testEnableDisable(enable: false),
                ),
                MaterialButton(
                  child: const Text("Test enable"),
                  color: Colors.grey,
                  onPressed: () => _testEnableDisable(enable: true),
                ),
                MaterialButton(
                  child: const Text("Test reset"),
                  color: Colors.grey,
                  onPressed: () => _testReset(),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _testTrackScreenWithoutProperties() async {
    await _segmentTracker.trackScreen(
      name: 'FlutterSegmentSdk Demo',
    );
  }

  Future<void> _testTrackScreenWithProperties(String key, String value) async {
    await _segmentTracker.trackScreen(
      name: 'FlutterSegmentSdk Demo',
      properties: <String, String>{key: value},
    );
  }

  Future<void> _testTrackEventWithoutProperties() async {
    await _segmentTracker.trackEvent(
      name: 'Demo event',
    );
  }

  Future<void> _testTrackEventWithProperties(String key, String value) async {
    await _segmentTracker.trackEvent(
      name: 'Demo event',
      properties: <String, String>{key: value},
    );
  }

  Future<void> _testIdentify(String userId, {Map<String, dynamic> traits}) async {
    await _segmentTracker.identify(userId: userId, traits: traits);
  }

  Future<void> _testEnableDisable({@required bool enable}) async {
    if (enable) {
      await _segmentTracker.enable();
    } else {
      await _segmentTracker.disable();
    }
  }

  Future<void> _testReset() async {
    await _segmentTracker.reset();
  }
}
