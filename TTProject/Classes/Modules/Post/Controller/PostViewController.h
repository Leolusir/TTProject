//
//  PostViewController.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "PostModel.h"

@interface PostViewController : BaseTableViewController

@property (nonatomic, strong) PostModel *post;

@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *userIdOne;
@property (nonatomic, strong) NSString *userIdTwo;

@end
