//
//  PostPublishResultModel.h
//  TTProject
//
//  Created by Ivan on 16/4/23.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "PostModel.h"

@protocol PostPublishResultModel

@end

@interface PostPublishResultModel : BaseModel

@property (nonatomic, strong) PostModel *post;

@end
