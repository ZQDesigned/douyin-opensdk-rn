#import <Foundation/Foundation.h>
#import "DouyinOpenSDK/DouyinOpenSDKErrorCode.h"

typedef NS_ENUM(NSInteger, AuthType) {
  /**
   * @brief 授权成功
   */
  AuthTypeSuccess,
  /**
   * @brief 用户取消授权
   */
  AuthTypeUserCanceled,
  /**
   * @brief 授权失败
   */
  AuthTypeFailed
};

NSString * _Nonnull AuthTypeToString(AuthType type) {
    switch (type) {
        case AuthTypeSuccess:
            return @"SUCCESS";
        case AuthTypeUserCanceled:
            return @"USER_CANCELED";
        case AuthTypeFailed:
            return @"FAILED";
    }
}

@interface AuthResult : NSObject

@property (nonatomic, assign, nonnull) NSString *authType;
@property (nonatomic, copy, nullable) NSString *authCode;
@property (nonatomic, copy, nullable) NSString *grantedPermissions;
@property (nonatomic, strong, nullable) NSNumber *errorCode;
@property (nonatomic, copy, nullable) NSString *errorMsg;

- (nonnull instancetype)initWithAuthType:(nonnull NSString *)authType
                       authCode:(nullable NSString *)authCode
            grantedPermissions:(nullable NSString *)grantedPermissions
                      errorCode:(nullable NSNumber *)errorCode
                       errorMsg:(nullable NSString *)errorMsg;

- (nonnull NSDictionary *)toDictionary;
@end

@interface Utility : NSObject

+ (UIViewController *)getCurrentViewController;

+ (UIViewController *)getTopViewController:(UIViewController *)rootViewController;

+ (NSNumber *)getErrorCodeValue:(DouyinOpenSDKErrorCode)errorCode;

@end



#ifdef RCT_NEW_ARCH_ENABLED
#import "RNRCTDouYinOpenSDKModuleSpec.h"

@interface RCTDouYinOpenSDKModule : NSObject <NativeRCTDouYinOpenSDKModuleSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RCTDouYinOpenSDKModule : NSObject <RCTBridgeModule>
#endif

@end
