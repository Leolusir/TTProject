//
//  AppInitResult.h
//  TTProject
//
//  Created by Ivan on 16/5/7.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"

@protocol AppInitResultModel

@end

@interface AppInitResultModel : BaseModel

@property (nonatomic, assign) NSInteger version;
@property (nonatomic, assign) NSInteger newMsg;

@end
