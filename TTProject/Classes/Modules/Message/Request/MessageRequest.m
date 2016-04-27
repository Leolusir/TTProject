//
//  MessageRequest.m
//  TTProject
//
//  Created by Ivan on 16/4/27.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "MessageRequest.h"

#define MESSAGE_RECORD_LIST                     @"/api/v1/message/record"
#define MESSAGE_LIST                            @"/api/v1/message"
#define MESSAGE_SEND                            @"/api/v1/message"

@implementation MessageRequest

+ (void)getRecordsWithParams:(NSDictionary *)params success:(void(^)(RecordListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:MESSAGE_RECORD_LIST parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        RecordListResultModel *resultModel = [[RecordListResultModel alloc] initWithDictionary:result error:&err];
        
        if (success) {
            success(resultModel);
        }
        
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}

+ (void)getMessagesWithParams:(NSDictionary *)params success:(void(^)(MessageResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] getWithUrl:MESSAGE_LIST parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        MessageResultModel *resultModel = [[MessageResultModel alloc] initWithDictionary:result error:&err];
        
        if (success) {
            success(resultModel);
        }
        
    } failure:^(StatusModel *status) {
        if (failure) {
            failure(status);
        }
    }];
}

+ (void)sendMessagesWithParams:(NSDictionary *)params success:(void(^)(MessageSendResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure
{
    [[TTNetworkManager sharedInstance] postWithUrl:MESSAGE_SEND parameters:params success:^(NSDictionary *result) {
        
        NSError *err = [[NSError alloc] init];
        
        MessageSendResultModel *resultModel = [[MessageSendResultModel alloc] initWithDictionary:result error:&err];
        
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
