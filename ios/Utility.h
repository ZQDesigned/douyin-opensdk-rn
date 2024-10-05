#import "DouyinOpenSDK/DouyinOpenSDKErrorCode.h"

@interface Utility : NSObject

+ (UIViewController *)getCurrentViewController;

+ (UIViewController *)getTopViewController:(UIViewController *)rootViewController;

+ (NSNumber *)getErrorCodeValue:(DouyinOpenSDKErrorCode)errorCode;

@end
