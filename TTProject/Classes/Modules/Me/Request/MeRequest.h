//
//  MeRequest.h
//  TTProject
//
//  Created by Ivan on 16/4/29.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseRequest.h"
#import "PostListResultModel.h"
#import "TitleListResultModel.h"

@interface MeRequest : BaseRequest

+ (void)getMyPostsWithParams:(NSDictionary *)params success:(void(^)(PostListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

+ (void)getMyTitlesWithParams:(NSDictionary *)params success:(void(^)(TitleListResultModel *resultModel))success failure:(void(^)(StatusModel *status))failure;

@end
