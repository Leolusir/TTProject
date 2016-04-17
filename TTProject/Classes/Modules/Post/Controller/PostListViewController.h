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

- (void)addPosts:(NSArray *)posts;
- (void)cleanUpPosts;

@end
