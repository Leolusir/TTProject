//
//  TopicRequest.h
//  TTProject
//
//  Created by Ivan on 16/4/22.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseRequest.h"
#import "TopicListResultModel.h"

@interface TopicRequest : BaseRequest

+ (void)getTopicsWithParams:(NSDictionary *)params success:(void(^)(TopicListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

@end
