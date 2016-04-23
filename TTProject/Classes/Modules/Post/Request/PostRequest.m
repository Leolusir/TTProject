//
//  PostRequest.m
//  TTProject
//
//  Created by Ivan on 16/4/19.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostRequest.h"

#define POST_VOTE                          @"/api/v1/vote"
#define POST_PUBLISH                       @"/api/v1/post"

@implementation PostRequest

+ (void)voteWithParams:(NSDictionary *)params success:(void(^)())success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] postWithUrl:POST_VOTE parameters:params success:^(NSDictionary *result) {
        
        if (success) {
            success();
        }
        
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}

+ (void)publishPostWithParams:(NSDictionary *)params success:(void(^)(PostPublishResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] postWithUrl:POST_PUBLISH parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        PostPublishResultModel *resultModel = [[PostPublishResultModel alloc] initWithDictionary:result error:&err];
        
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
