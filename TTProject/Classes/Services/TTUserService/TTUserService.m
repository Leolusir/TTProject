//
//  TTUserService.m
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTUserService.h"

@interface TTUserService ()

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, assign) NSUInteger birthYear;
@property (nonatomic, assign) NSUInteger birthMonth;
@property (nonatomic, assign) NSUInteger birthDay;
@property (nonatomic, assign) CGFloat age;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *star;
@property (nonatomic, strong) NSString *token;

@end

@implementation TTUserService

+ (TTUserService *)sharedService {
    static dispatch_once_t onceToken;
    static TTUserService *service = nil;
    dispatch_once(&onceToken, ^{
        service = [[TTUserService alloc] init];
    });
    return service;
}

- (instancetype)init {
    
    self = [super init];
    
    if ( self ) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.isLogin = [defaults boolForKey:@"isLogin"];
        
        if ( self.isLogin ) {
            
            self.id = [defaults stringForKey:@"userId"];
            self.birthYear = [defaults integerForKey:@"birthYear"];
            self.birthMonth = [defaults integerForKey:@"birthMonth"];
            self.birthDay = [defaults integerForKey:@"birthDay"];
            self.age = [defaults floatForKey:@"age"];
            self.gender = [defaults stringForKey:@"gender"];
            self.createTime = [defaults stringForKey:@"account"];
            self.star = [defaults stringForKey:@"star"];
            self.token = [defaults stringForKey:@"token"];
            
        }
    }
    
    return self;
}

//登录注册存储用户信息
- (void)saveUserInfo:(UserModel *)userInfo token:(NSString *)token
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:userInfo.id forKey:@"userId"];
    [defaults setInteger:userInfo.birthYear forKey:@"birthYear"];
    [defaults setInteger:userInfo.birthMonth forKey:@"birthMonth"];
    [defaults setInteger:userInfo.birthDay forKey:@"birthDay"];
    [defaults setFloat:userInfo.age forKey:@"age"];
    [defaults setObject:userInfo.gender forKey:@"gender"];
    [defaults setObject:userInfo.createTime forKey:@"createTime"];
    [defaults setObject:userInfo.star forKey:@"star"];
    [defaults setObject:token forKey:@"token"];
    [defaults setBool:YES forKey:@"isLogin"];
    [defaults synchronize];
    
    self.id = userInfo.id;
    self.birthYear = userInfo.birthYear;
    self.birthMonth = userInfo.birthMonth;
    self.birthDay = userInfo.birthDay;
    self.age = userInfo.age;
    self.gender = userInfo.gender;
    self.createTime = userInfo.createTime;
    self.star = userInfo.star;
    self.token = token;
    self.isLogin = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_APP_USER_SIGNIN object:nil];
    
}

//退出登录清除信息
- (void)logout {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"userId"];
    [defaults removeObjectForKey:@"birthYear"];
    [defaults removeObjectForKey:@"birthMonth"];
    [defaults removeObjectForKey:@"birthDay"];
    [defaults removeObjectForKey:@"age"];
    [defaults removeObjectForKey:@"gender"];
    [defaults removeObjectForKey:@"createTime"];
    [defaults removeObjectForKey:@"star"];
    [defaults removeObjectForKey:@"token"];
    [defaults setBool:NO forKey:@"isLogin"];
    [defaults synchronize];
    
    self.id = @"";
    self.birthYear = 0;
    self.birthMonth = 0;
    self.birthDay = 0;
    self.age = 0;
    self.gender = @"";
    self.createTime = 0;
    self.star = @"";
    self.token = @"";
    self.isLogin = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_APP_USER_SIGNOUT object:nil];
    
    [[TTNavigationService sharedService] openUrl:@"jump://sign"];
}

@end
