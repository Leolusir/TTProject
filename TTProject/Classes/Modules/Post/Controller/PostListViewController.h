//
//  PostListViewController.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "PostModel.h"

@interface PostListViewController : BaseTableViewController

@property (nonatomic, assign, readonly) CLLocationDegrees latitude;
@property (nonatomic, assign, readonly) CLLocationDegrees longitude;
@property (nonatomic, strong, readonly) NSString *country;
@property (nonatomic, assign) BOOL needLocation;

- (void)initData;
- (void)addPosts:(NSArray *)posts;
- (void)insertPost:(PostModel *)post atIndex:(NSInteger)index;
- (void)cleanUpPosts;

@end
