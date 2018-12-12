#import "SegmentFlutterSdkPlugin.h"
#import <segment_flutter_sdk/segment_flutter_sdk-Swift.h>

@implementation SegmentFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSegmentFlutterSdkPlugin registerWithRegistrar:registrar];
}
@end
