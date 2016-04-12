//
//  TTUserService.h
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

@interface TTUserService : NSObject

@property (nonatomic, assign, readonly) BOOL isLogin;

+ (TTUserService *)sharedService;

@end
