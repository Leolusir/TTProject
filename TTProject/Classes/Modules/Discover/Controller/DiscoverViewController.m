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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"发现" titleColor:Color_Gray1 selectedTitleColor:Color_Green1 icon:[UIImage imageNamed:@"icon_tabbar_discover_normal"] selectedIcon:[UIImage imageNamed:@"icon_tabbar_discover_selected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发现";
    
    [self addNavigationBar];
    
}

#pragma mark - Override Methods

- (void)addTableView
{
    [super addTableView];
    
    self.tableView.top = NAVBAR_HEIGHT;
    self.tableView.height = SCREEN_HEIGHT - NAVBAR_HEIGHT - TABBAR_HEIGHT;
    
}

- (void)addNavigationBar
{
    [super addNavigationBar];
   
    UIImage *addImage = [UIImage imageNamed:@"icon_nav_add"];
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

#pragma mark - Event Response

- (void)handleAddPostButton
{
    [[TTNavigationService sharedService] openUrl:@"jump://post_publish"];
}

@end
