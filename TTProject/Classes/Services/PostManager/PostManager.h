//
//  PostManager.h
//  TTProject
//
//  Created by Ivan on 16/5/7.
//  Copyright © 2016年 ivan. All rights reserved.
//

@interface PostManager : NSObject

+ (NSUInteger)contentRowCountAtPostId:(NSString *)postId;

+ (void)contentRowCount:(NSUInteger)count forPostId:(NSString *)postId;

+ (CGSize)contentSizeAtPostId:(NSString *)postId withRowCount:(NSUInteger)rowCount;

+ (void)contentSize:(CGSize)size forPostId:(NSString *)postId rowCount:(NSUInteger)rowCount;

@end
