//
//  TTUserService.h
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "UserModel.h"

@interface TTUserService : NSObject

@property (nonatomic, assign, readonly) BOOL isLogin;
@property (nonatomic, strong, readonly) NSString *id;
@property (nonatomic, assign, readonly) NSUInteger birthYear;
@property (nonatomic, assign, readonly) NSUInteger birthMonth;
@property (nonatomic, assign, readonly) NSUInteger birthDay;
@property (nonatomic, assign, readonly) CGFloat age;
@property (nonatomic, strong, readonly) NSString *gender;
@property (nonatomic, strong, readonly) NSString *createTime;
@property (nonatomic, strong, readonly) NSString *star;
@property (nonatomic, strong, readonly) NSString *token;

+ (TTUserService *)sharedService;

//登录注册存储用户信息
- (void)saveUserInfo:(UserModel *)userInfo token:(NSString *)token;
//退出登录清除信息
- (void)logout;

@end
