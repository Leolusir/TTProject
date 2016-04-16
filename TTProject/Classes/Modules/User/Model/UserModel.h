//
//  UserModel.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"

@protocol UserModel

@end

@interface UserModel : BaseModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, assign) NSUInteger birthYear;
@property (nonatomic, assign) NSUInteger birthMonth;
@property (nonatomic, assign) NSUInteger birthDay;
@property (nonatomic, assign) CGFloat age;
@property (nonatomic, strong) NSString *gender; //m男 f女
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *star;

@end
