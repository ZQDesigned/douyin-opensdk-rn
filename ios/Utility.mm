#import <UIKit/UIKit.h>
#import "Utility.h"

@implementation Utility

+ (UIViewController *)getCurrentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getTopViewController:rootViewController];
}

+ (UIViewController *)getTopViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController) {
        return [self getTopViewController:rootViewController.presentedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        return [self getTopViewController:[(UINavigationController *)rootViewController topViewController]];
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        return [self getTopViewController:[(UITabBarController *)rootViewController selectedViewController]];
    } else {
        return rootViewController;
    }
}

+ (NSNumber *)getErrorCodeValue:(DouyinOpenSDKErrorCode)errorCode {
  return [NSNumber numberWithInteger:errorCode];
}

@end
