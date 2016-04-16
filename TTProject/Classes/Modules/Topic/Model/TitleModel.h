//
//  TitleModel.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"

@protocol TitleModel

@end

@interface TitleModel : BaseModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createUserId;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, strong) NSString *createTime;

@end