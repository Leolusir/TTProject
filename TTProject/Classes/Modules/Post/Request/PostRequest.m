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
#define POST_TOKEN                         @"/api/v1/qiniu"
#define POST_FOR_TITLE                     @"/api/v1/post/bytitle"

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

+ (void)getQiniuTokenWithSuccess:(void(^)(NSString *token))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:POST_TOKEN parameters:nil success:^(NSDictionary *result) {
        
        NSString *token = [result objectForKey:@"authToken"];
        
        if (success) {
            success(token);
        }
        
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}

+ (void)getTitlePostsWithParams:(NSDictionary *)params success:(void(^)(PostListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:POST_FOR_TITLE parameters:params success:^(NSDictionary *result) {
        
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
