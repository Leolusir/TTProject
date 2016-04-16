//
//  DiscoverRequest.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "DiscoverRequest.h"

#define DISCOVER_GET_POSTS                          @"/api/v1/post"

@implementation DiscoverRequest

+ (void)getPostsWithParams:(NSDictionary *)params success:(void(^)(PostListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:DISCOVER_GET_POSTS parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        PostListResultModel *resultModel = [[PostListResultModel alloc] initWithDictionary:result error:&err];
        
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
