//
//  TopicModel.h
//  TTProject
//
//  Created by Ivan on 16/4/22.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"

@protocol TopicModel

@end

@interface TopicModel : BaseModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, assign) NSInteger ref;

@end
