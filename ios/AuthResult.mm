#import "AuthResult.h"

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
