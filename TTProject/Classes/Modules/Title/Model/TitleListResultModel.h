//
//  TopicListResultModel.h
//  TTProject
//
//  Created by Ivan on 16/4/22.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "TitleModel.h"

@protocol TitleListResultModel

@end

@interface TitleListResultModel : BaseModel

@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, strong) NSString *wp;
@property (nonatomic, strong) NSArray<TitleModel, Optional> *titles;
@property (nonatomic, strong) NSArray<TitleModel, Optional> *hotTitles;

@end
