//
//  MessageSendResultModel.h
//  TTProject
//
//  Created by Ivan on 16/4/27.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "MessageModel.h"
#import "PostModel.h"

@protocol MessageSendResultModel

@end

@interface MessageSendResultModel : BaseModel

@property (nonatomic, strong) MessageModel *message;

@end