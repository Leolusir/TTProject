//
//  MessageResultModel.h
//  TTProject
//
//  Created by Ivan on 16/4/27.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "MessageModel.h"
#import "PostModel.h"

@protocol MessageResultModel

@end

@interface MessageResultModel : BaseModel

@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, strong) NSString *wp;
@property (nonatomic, strong) NSArray<MessageModel, Optional> *messages;
@property (nonatomic, strong) PostModel *post;

@end
