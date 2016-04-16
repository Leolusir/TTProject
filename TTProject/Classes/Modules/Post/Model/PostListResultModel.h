//
//  PostListResultModel.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "PostModel.h"

@protocol PostListResultModel

@end

@interface PostListResultModel : BaseModel

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalElements;
@property (nonatomic, strong) NSArray<PostModel> *posts;

@end