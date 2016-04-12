//
//  ImageUnitModel.h
//  TTProject
//
//  Created by Ivan on 16/2/10.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"

@protocol ImageUnitModel

@end

@interface ImageUnitModel : BaseModel

@property (nonatomic, strong) NSString *src;
@property (nonatomic, assign) CGFloat ar;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;

@end
