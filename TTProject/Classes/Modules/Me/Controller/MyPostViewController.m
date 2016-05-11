//
//  MyPostViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/29.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "MyPostViewController.h"
#import "MeRequest.h"

@interface MyPostViewController ()

@end

@implementation MyPostViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    self.needLocation = NO;
    
    [super viewDidLoad];
    
    self.emptyNotice = @"还没有发过动态";
    
    self.title = @"我的动态";
    
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

//- (void)addNavigationBar
//{
//    [super addNavigationBar];
//    
//    UIImage *addImage = [UIImage imageNamed:@"icon_nav_add"];
//    UIButton *addPostButton = [UIButton rightBarButtonWithImage:addImage highlightedImage:addImage target:self action:@selector(handleAddPostButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationBar setRightBarButton:addPostButton];
//}

#pragma mark - Private Methods

- (void)requestData
{
    if (![TTUserService sharedService].isLogin) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:[TTUserService sharedService].id forKey:@"userId"];
    
    
    if ( LoadingTypeLoadMore == self.loadingType ) {
        [params setSafeObject:self.wp forKey:@"wp"];
    } else {
        [params setSafeObject:@"0" forKey:@"wp"];
    }
    
    weakify(self);
    
    [MeRequest getMyPostsWithParams:params success:^(PostListResultModel *resultModel) {
        
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
    [[TTNavigationService sharedService] openUrl:@"jump://post_publish"];
}

#pragma mark - Notification Methods

- (void)postSuccess:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    PostModel *post = [userInfo objectForKey:@"post"];
    
    if ( post ) {
        [self hideEmptyTips];
        [self insertPost:post atIndex:0];
        [self reloadData];
    }
}

@end
