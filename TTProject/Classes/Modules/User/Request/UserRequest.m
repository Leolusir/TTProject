//
//  UserRequest.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "UserRequest.h"

#define USER_GET_CAPTCHA_REQUEST_URL                    @"/api/v1/user/code"
#define USER_LOGIN_REQUEST_URL                          @"/api/v1/user/login"

@implementation UserRequest

+ (void)loginWithParams:(NSDictionary *)params success:(void(^)(SignInResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] postWithUrl:USER_LOGIN_REQUEST_URL parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        SignInResultModel *resultModel = [[SignInResultModel alloc] initWithDictionary:result error:&err];
        
        if (success) {
            success(resultModel);
        }
        
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}

+ (void)getCaptchaWithParams:(NSDictionary *)params success:(void(^)())success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:USER_GET_CAPTCHA_REQUEST_URL parameters:params success:^(NSDictionary *result) {
        
        if (success) {
            success();
        }
        
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}

@end
