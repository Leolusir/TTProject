//
//  MeRequest.m
//  TTProject
//
//  Created by Ivan on 16/4/29.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "MeRequest.h"

#define ME_GET_POSTS                          @"/api/v1/user/post"
#define ME_GET_TITLES                          @"/api/v1/user/title"

@implementation MeRequest

+ (void)getMyPostsWithParams:(NSDictionary *)params success:(void(^)(PostListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:ME_GET_POSTS parameters:params success:^(NSDictionary *result) {
        
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

+ (void)getMyTitlesWithParams:(NSDictionary *)params success:(void(^)(TitleListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:ME_GET_TITLES parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        TitleListResultModel *resultModel = [[TitleListResultModel alloc] initWithDictionary:result error:&err];
        
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
