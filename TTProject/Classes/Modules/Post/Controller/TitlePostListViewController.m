//
//  TitlePostListViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/25.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TitlePostListViewController.h"
#import "PostRequest.h"

@implementation TitlePostListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    self.needLocation = YES;
    
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

- (void)addNavigationBar
{
    [super addNavigationBar];
    
    UIImage *addImage = [UIImage imageNamed:@"icon_nav_write"];
    UIButton *addPostButton = [UIButton rightBarButtonWithImage:addImage highlightedImage:addImage target:self action:@selector(handleAddPostButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:addPostButton];
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
    [params setSafeObject:self.title forKey:@"title"];
    
    if ( LoadingTypeLoadMore == self.loadingType ) {
        [params setSafeObject:self.wp forKey:@"wp"];
    } else {
        [params setSafeObject:@"0" forKey:@"wp"];
    }
    
    weakify(self);
    
    [PostRequest getTitlePostsWithParams:params success:^(PostListResultModel *resultModel) {
        
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

#pragma mark - Event Response

- (void)handleAddPostButton
{
    [[TTNavigationService sharedService] openUrl:[NSString stringWithFormat:@"jump://post_publish?title=%@", self.title]];
}

@end
