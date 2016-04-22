//
//  PostPublishViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostPublishViewController.h"

@implementation PostPublishViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发表";
    
    [self addNavigationBar];
    
}

#pragma mark - Private Methods

- (void)addNavigationBar
{
    [super addNavigationBar];
    
    UIImage *publishImage = [UIImage imageNamed:@"icon_nav_publish"];
    UIButton *publishPostButton = [UIButton rightBarButtonWithImage:publishImage highlightedImage:publishImage target:self action:@selector(publishPost) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:publishPostButton];
}

#pragma mark - Event Response

- (void)publishPost
{
    DBG(@"publishPost");
}


@end
