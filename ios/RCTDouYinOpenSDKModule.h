
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNRCTDouYinOpenSDKModuleSpec.h"

@interface RCTDouYinOpenSDKModule : NSObject <NativeRCTDouYinOpenSDKModuleSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RCTDouYinOpenSDKModule : NSObject <RCTBridgeModule>
#endif

@end
