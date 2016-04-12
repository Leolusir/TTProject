//
//  ResponseModel.h
//  TTProject
//
//  Created by Ivan on 16/1/24.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "StatusModel.h"

@interface ResponseModel : BaseModel

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDictionary<Optional>* result;

@end