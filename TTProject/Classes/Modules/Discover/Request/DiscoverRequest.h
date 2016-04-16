//
//  DiscoverRequest.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseRequest.h"
#import "PostListResultModel.h"

@interface DiscoverRequest : BaseRequest

+ (void)getPostsWithParams:(NSDictionary *)params success:(void(^)(PostListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

@end
