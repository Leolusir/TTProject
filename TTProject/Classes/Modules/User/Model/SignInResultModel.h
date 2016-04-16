//
//  SignInResultModel.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@protocol SignInResultModel

@end

@interface SignInResultModel : BaseModel

@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSString *token;

@end