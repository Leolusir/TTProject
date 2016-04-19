//
//  CommentModel.h
//  TTProject
//
//  Created by Ivan on 16/4/19.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@protocol CommentModel

@end

@interface CommentModel : BaseModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) UserModel *user;

@end
