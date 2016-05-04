//
//  MessageRequest.h
//  TTProject
//
//  Created by Ivan on 16/4/27.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseRequest.h"
#import "RecordListResultModel.h"
#import "MessageResultModel.h"
#import "MessageSendResultModel.h"

@interface MessageRequest : BaseRequest

+ (void)getRecordsWithParams:(NSDictionary *)params success:(void(^)(RecordListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

+ (void)deleteRecordWithId:(NSString *)recordId success:(void(^)())success failure:(void(^)(StatusModel *status))failure;

+ (void)getMessagesWithParams:(NSDictionary *)params success:(void(^)(MessageResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

+ (void)sendMessagesWithParams:(NSDictionary *)params success:(void(^)(MessageSendResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

@end
