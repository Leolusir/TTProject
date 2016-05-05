//
//  OverwatchViewController.m
//  TTProject
//
//  Created by Ivan on 16/5/5.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "OverwatchViewController.h"
#import "DiscoverRequest.h"

@interface OverwatchViewController ()

@end

@implementation OverwatchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    
    self.needLocation = YES;
    
    [super viewDidLoad];
    
    [self addNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSuccess:) name:kNOTIFY_APP_POST_PUBLISH_SUCCESS object:nil];
    
    
}

#pragma mark - Override Methods

- (void)addTableView
{
    [super addTableView];
    
    self.tableView.top = NAVBAR_HEIGHT;
    self.tableView.height = SCREEN_HEIGHT - NAVBAR_HEIGHT;
    
}

#pragma mark - Private Methods

- (void)requestData
{
    if (![TTUserService sharedService].isLogin) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:@(self.longitude) forKey:@"longitude"];
    [params setSafeObject:@(self.latitude) forKey:@"latitude"];
    [params setSafeObject:@"2" forKey:@"distance"];
    [params setSafeObject:self.country forKey:@"country"];
    [params setSafeObject:[TTUserService sharedService].id forKey:@"userId"];
    
    
    if ( LoadingTypeLoadMore == self.loadingType ) {
        [params setSafeObject:self.wp forKey:@"wp"];
    } else {
        [params setSafeObject:@"0" forKey:@"wp"];
    }
    
    weakify(self);
    
    [DiscoverRequest getPostsWithParams:params success:^(PostListResultModel *resultModel) {
        
        strongify(self);
        
        self.tableView.showsPullToRefresh = YES;
        
        if (resultModel) {
            
            if ( LoadingTypeLoadMore == self.loadingType ) {
                [self finishLoadMore];
            } else {
                [self finishRefresh];
                [self cleanUpPosts];
            }
            
            [self addPosts:resultModel.posts];
            
            self.wp = resultModel.wp;
            
            if( resultModel.isEnd ){
                self.tableView.showsInfiniteScrolling = NO;
            } else {
                self.tableView.showsInfiniteScrolling = YES;
            }
            
            [self reloadData];
            
        }
        
        
    } failure:^(StatusModel *status) {
        
        DBG(@"%@", status);
        
        strongify(self);
        
        [self showNotice:status.msg];
        
        if ( LoadingTypeLoadMore == self.loadingType ) {
            [self finishLoadMore];
        } else {
            self.tableView.showsPullToRefresh = YES;
            [self finishRefresh];
        }
        
    }];
    
}

#pragma mark - Notification Methods

- (void)postSuccess:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    PostModel *post = [userInfo objectForKey:@"post"];
    
    if ( post ) {
        [self insertPost:post atIndex:0];
        [self reloadData];
    }
}

@end
