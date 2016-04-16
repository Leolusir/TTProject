//
//  TopicListViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TopicListViewController.h"

@interface TopicListViewController ()

@end

@implementation TopicListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
}

#pragma mark - Private Methods

- (void)initData
{
    self.loadingType = LoadingTypeInit;
    [self loadData];
}

- (void)loadData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ( LoadingTypeLoadMore == self.loadingType ) {
        
    } else {
        
    }
    
}

@end
