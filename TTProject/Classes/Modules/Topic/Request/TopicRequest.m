//
//  TopicRequest.m
//  TTProject
//
//  Created by Ivan on 16/4/22.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TopicRequest.h"

#define TOPIC_GET_TITLES                          @"/api/v1/post/title"

@implementation TopicRequest

+ (void)getTopicsWithParams:(NSDictionary *)params success:(void(^)(TopicListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:TOPIC_GET_TITLES parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        TopicListResultModel *resultModel = [[TopicListResultModel alloc] initWithDictionary:result error:&err];
        
        if (success) {
            success(resultModel);
        }
        
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}

@end
