//
//  DiscoverViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverRequest.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    self.hideNavigationBar = YES;
    
    [super viewDidLoad];
    
}

#pragma mark - Override Methods

- (void)addTableView
{
    [super addTableView];
    
    self.tableView.top = NAVBAR_HEIGHT;
    self.tableView.height = SCREEN_HEIGHT - NAVBAR_HEIGHT - TABBAR_HEIGHT;
    
}

#pragma mark - Private Methods

- (void)loadData
{
    if (![TTUserService sharedService].isLogin) {
        return;
    }
    
    //TODO: 参数待实装
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:@"120.121806" forKey:@"longitude"];
    [params setSafeObject:@"30.274818" forKey:@"latitude"];
    [params setSafeObject:@"2" forKey:@"distance"];
    [params setSafeObject:@"中国" forKey:@"country"];
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
            [self finishRefresh];
        }
        
    }];
    
}


@end
