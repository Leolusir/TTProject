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
    
    self.needLocation = NO;
    
    [super viewDidLoad];
    
    [self addNavigationBar];

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
                
                if ( !resultModel.posts || resultModel.posts.count == 0 ) {
                    [self showEmptyTips:self.emptyNotice ownerView:self.tableView];
                }
                
                if ( LoadingTypeInit == self.loadingType ) {
                    [TTActivityIndicatorView hideActivityIndicatorForView:self.view animated:YES];
                }
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
            
            if ( LoadingTypeInit == self.loadingType ) {
                [TTActivityIndicatorView hideActivityIndicatorForView:self.view animated:YES];
            }
        }
        
    }];
    
}

@end
