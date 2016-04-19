//
//  PostRequest.m
//  TTProject
//
//  Created by Ivan on 16/4/19.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostRequest.h"

#define POST_VOTE                          @"/api/v1/vote"

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

@end
