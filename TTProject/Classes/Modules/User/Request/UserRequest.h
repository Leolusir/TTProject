//
//  UserRequest.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseRequest.h"
#import "SignInUpResultModel.h"

@interface UserRequest : BaseRequest

+ (void)signUpWithParams:(NSDictionary *)params success:(void(^)(SignInUpResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

+ (void)signInWithParams:(NSDictionary *)params success:(void(^)(SignInUpResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

+ (void)getCaptchaWithParams:(NSDictionary *)params success:(void(^)())success failure:(void(^)(StatusModel *status))failure;

@end
