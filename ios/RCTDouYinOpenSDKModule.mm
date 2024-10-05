#import "RCTDouYinOpenSDKModule.h"
#import "DouyinOpenSDK/DouyinOpenSDKAuth.h"
#import "Utility.h"
#import "AuthResult.h"

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
