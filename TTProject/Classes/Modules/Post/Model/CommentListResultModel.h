//
//  CommentListResultModel.h
//  TTProject
//
//  Created by Ivan on 16/4/19.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "CommentModel.h"

@protocol CommentListResultModel

@end

@interface CommentListResultModel : BaseModel

@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, strong) NSString *wp;
@property (nonatomic, strong) NSArray<CommentModel> *posts;

@end
