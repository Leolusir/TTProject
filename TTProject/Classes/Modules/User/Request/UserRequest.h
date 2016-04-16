//
//  UserRequest.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseRequest.h"
#import "SignInResultModel.h"

@interface UserRequest : BaseRequest

+ (void)loginWithParams:(NSDictionary *)params success:(void(^)(SignInResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

+ (void)getCaptchaWithParams:(NSDictionary *)params success:(void(^)())success failure:(void(^)(StatusModel *status))failure;

@end
