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

@property (nonatomic, strong) NSMutableArray<PostModel> *posts;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger page;

@end
