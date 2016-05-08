//
//  UserRequest.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "UserRequest.h"

#define USER_GET_CAPTCHA_REQUEST_URL                    @"/api/v1/user/code"
#define USER_SIGNUP_REQUEST_URL                          @"/api/v1/user"
#define USER_SIGNIN_REQUEST_URL                          @"/api/v1/user/login"
#define APP_INIT_REQUEST_URL                          @"/api/v1/support/init"

@implementation UserRequest

+ (void)signUpWithParams:(NSDictionary *)params success:(void(^)(SignInUpResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] postWithUrl:USER_SIGNUP_REQUEST_URL parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        SignInUpResultModel *resultModel = [[SignInUpResultModel alloc] initWithDictionary:result error:&err];
        
        if (success) {
            success(resultModel);
        }
        
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}

+ (void)signInWithParams:(NSDictionary *)params success:(void(^)(SignInUpResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] postWithUrl:USER_SIGNIN_REQUEST_URL parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        SignInUpResultModel *resultModel = [[SignInUpResultModel alloc] initWithDictionary:result error:&err];
        
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

+ (void)registerClientIdWithParams:(NSDictionary *)params success:(void(^)(AppInitResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:APP_INIT_REQUEST_URL parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        AppInitResultModel *resultModel = [[AppInitResultModel alloc] initWithDictionary:result error:&err];
        
        if (success) {
            success(resultModel);
        }
        
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}

@end
