//
//  TopicRequest.h
//  TTProject
//
//  Created by Ivan on 16/4/22.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseRequest.h"
#import "TitleListResultModel.h"

@interface TitleRequest : BaseRequest

+ (void)getTopicsWithParams:(NSDictionary *)params success:(void(^)(TitleListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

@end
