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

@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, assign) BOOL needLocation;
@property (nonatomic, strong) NSString *emptyNotice;

- (void)initData;
- (void)addPosts:(NSArray *)posts;
- (void)insertPost:(PostModel *)post atIndex:(NSInteger)index;
- (void)cleanUpPosts;

@end
