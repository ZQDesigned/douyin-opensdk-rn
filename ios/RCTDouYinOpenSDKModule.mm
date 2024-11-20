#import "RCTDouYinOpenSDKModule.h"
#import "DouyinOpenSDK/DouyinOpenSDKAuth.h"
#import <UIKit/UIKit.h>

@implementation AuthResult

- (instancetype)initWithAuthType:(nonnull NSString *)authType
                       authCode:(nullable NSString *)authCode
            grantedPermissions:(nullable NSString *)grantedPermissions
                      errorCode:(nullable NSNumber *)errorCode
                       errorMsg:(nullable NSString *)errorMsg {
    self = [super init];
    if (self) {
        _authType = authType;
        _authCode = [authCode copy];
        _grantedPermissions = [grantedPermissions copy];
        _errorCode = errorCode;
        _errorMsg = [errorMsg copy];
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"authType"] = self.authType;
    if (self.authCode) {
        dict[@"authCode"] = self.authCode;
    }
    if (self.grantedPermissions) {
        dict[@"grantedPermissions"] = self.grantedPermissions;
    }
    if (self.errorCode) {
        dict[@"errorCode"] = self.errorCode;
    }
    if (self.errorMsg) {
        dict[@"errorMsg"] = self.errorMsg;
    }

    return [dict copy];
}
@end

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


@implementation RCTDouYinOpenSDKModule
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initSDK:(NSString *)clientKey)
{
  [[DouyinOpenSDKApplicationDelegate sharedInstance] registerAppId:clientKey];
}

RCT_EXPORT_METHOD(authorize:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
  // 1. 在需要发起授权或登录的代码中构造发送给抖音的授权请求。
  DouyinOpenSDKAuthRequest *request = [[DouyinOpenSDKAuthRequest alloc] init];
  // 2. 设置授权域 permissions（scope）。
  request.permissions = [NSOrderedSet orderedSetWithObject:@"user_info"];
  UIViewController *currentViewController = [Utility getCurrentViewController];
  // 3.执行请求。
  if (currentViewController) {
    [request sendAuthRequestViewController:currentViewController completeBlock:^(DouyinOpenSDKAuthResponse * _Nonnull resp) {
      switch (resp.errCode) {
        case DouyinOpenSDKSuccess:
        case DouyinOpenSDKSuccess20000: {
          NSOrderedSet<NSString *> *grantedPermissionsSet = resp.grantedPermissions;
          NSString *grantedPermissionsString = grantedPermissionsSet ? [[grantedPermissionsSet array] componentsJoinedByString:@","] : nil;
          AuthResult *authResult = [[AuthResult alloc] initWithAuthType:AuthTypeToString(AuthTypeSuccess)
                                                               authCode:resp.code
                                                     grantedPermissions:grantedPermissionsString
                                                              errorCode:@(0)
                                                               errorMsg:resp.errString];
          resolve([authResult toDictionary]);
          break;
        }
        case DouyinOpenSDKErrorCodeUserCanceled: {
          NSOrderedSet<NSString *> *grantedPermissionsSet = resp.grantedPermissions;
          NSString *grantedPermissionsString = grantedPermissionsSet ? [[grantedPermissionsSet array] componentsJoinedByString:@","] : nil;
          AuthResult *authResult = [[AuthResult alloc] initWithAuthType:AuthTypeToString(AuthTypeUserCanceled)
                                                               authCode:resp.code
                                                     grantedPermissions:grantedPermissionsString
                                                              errorCode:@(-2)
                                                               errorMsg:resp.errString];
          resolve([authResult toDictionary]);
          break;
        }
        default: {
          NSOrderedSet<NSString *> *grantedPermissionsSet = resp.grantedPermissions;
          NSString *grantedPermissionsString = grantedPermissionsSet ? [[grantedPermissionsSet array] componentsJoinedByString:@","] : nil;
          AuthResult *authResult = [[AuthResult alloc] initWithAuthType:AuthTypeToString(AuthTypeFailed)
                                                               authCode:resp.code
                                                     grantedPermissions:grantedPermissionsString
                                                              errorCode:[Utility getErrorCodeValue:resp.errCode]
                                                               errorMsg:resp.errString];
          resolve([authResult toDictionary]);
          break;
        }
      }
      }];
  } else {
    reject(@"no_view_controller", @"Could not find current UIViewController", nil);
  }
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRCTDouYinOpenSDKModuleSpecJSI>(params);
}
#endif

@end
