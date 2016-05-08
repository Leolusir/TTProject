//
//  PostManager.m
//  TTProject
//
//  Created by Ivan on 16/5/7.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostManager.h"

@interface PostManager ()

@end

@implementation PostManager

+ (PostManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static PostManager *service = nil;
    dispatch_once(&onceToken, ^{
        service = [[PostManager alloc] init];
    });
    return service;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSUInteger)contentRowCountAtPostId:(NSString *)postId
{
    return 0;
}

+ (void)contentRowCount:(NSUInteger)count forPostId:(NSString *)postId
{
    
}

+ (CGSize)contentSizeAtPostId:(NSString *)postId withRowCount:(NSUInteger)rowCount
{
    return CGSizeZero;
}

+ (void)contentSize:(CGSize)size forPostId:(NSString *)postId rowCount:(NSUInteger)rowCount
{
    
}

@end
