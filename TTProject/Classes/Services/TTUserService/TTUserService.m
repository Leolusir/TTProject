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
@property (nonatomic, assign) NSUInteger birthYear;
@property (nonatomic, assign) NSUInteger birthMonth;
@property (nonatomic, assign) NSUInteger birthDay;
@property (nonatomic, assign) CGFloat age;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) NSUInteger createTime;
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
            
        }
    }
    
    return self;
}

@end
