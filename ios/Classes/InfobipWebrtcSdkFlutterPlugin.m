#import "InfobipWebrtcSdkFlutterPlugin.h"
#if __has_include(<infobip_voice/infobip_voice-Swift.h>)
#import <infobip_voice/infobip_voice-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "infobip_voice-Swift.h"
#endif

@implementation InfobipWebrtcSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInfobipWebrtcSdkFlutterPlugin registerWithRegistrar:registrar];
}
@end
