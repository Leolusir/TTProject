//
//  RecordListResultModel.h
//  TTProject
//
//  Created by Ivan on 16/4/27.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "RecordModel.h"

@protocol RecordListResultModel

@end

@interface RecordListResultModel : BaseModel

@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, strong) NSString *wp;
@property (nonatomic, strong) NSArray<RecordModel> *records;

@end
