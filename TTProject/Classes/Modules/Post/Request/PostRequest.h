//
//  PostRequest.h
//  TTProject
//
//  Created by Ivan on 16/4/19.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseRequest.h"

@interface PostRequest : BaseRequest

+ (void)voteWithParams:(NSDictionary *)params success:(void(^)())success failure:(void(^)(StatusModel *status))failure;

@end
