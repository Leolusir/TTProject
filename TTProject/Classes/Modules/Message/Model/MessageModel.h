//
//  MessageModel.h
//  TTProject
//
//  Created by Ivan on 16/4/27.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"

@protocol MessageModel

@end

@interface MessageModel : BaseModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString *userIdOne;
@property (nonatomic, strong) NSString *userIdTwo;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *createTime;

@end
