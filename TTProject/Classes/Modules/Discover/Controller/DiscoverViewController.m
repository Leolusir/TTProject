//
//  DiscoverViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "DiscoverViewController.h"
#import "TTMapViewController.h"
#import "DiscoverRequest.h"

@interface DiscoverViewController () <TTMapViewDelegate>

@end

@implementation DiscoverViewController

#pragma mark - Life Cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"附近" titleColor:Color_Gray1 selectedTitleColor:Color_Green1 icon:[UIImage imageNamed:@"icon_tabbar_around_normal"] selectedIcon:[UIImage imageNamed:@"icon_tabbar_around_selected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.needLocation = YES;
    
    [super viewDidLoad];
    
    self.title = @"附近";
    
    [self addNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignIn) name:kNOTIFY_APP_USER_SIGNIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignOut) name:kNOTIFY_APP_USER_SIGNOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSuccess:) name:kNOTIFY_APP_POST_PUBLISH_SUCCESS object:nil];

    
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
   
    UIImage *addImage = [UIImage imageNamed:@"icon_nav_write"];
    UIButton *addPostButton = [UIButton rightBarButtonWithImage:addImage highlightedImage:addImage target:self action:@selector(handleAddPostButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:addPostButton];
    
    UIImage *locationImage = [UIImage imageNamed:@"icon_nav_telescope"];
    UIButton *locationButton = [UIButton rightBarButtonWithImage:locationImage highlightedImage:locationImage target:self action:@selector(handleLocationButton) forControlEvents:UIControlEventTouchUpInside];
    locationButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [self.navigationBar setLeftBarButton:locationButton];
    
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

#pragma mark - Event Response

- (void)handleAddPostButton
{
    [[TTNavigationService sharedService] openUrl:@"jump://post_publish"];
}

- (void)handleLocationButton
{
    DBG(@"handleLocationButton");
    
    TTMapViewController *vc = [[TTMapViewController alloc] init];
    vc.delegate = self;
    
    TTNavigationController *navigationController = [[ApplicationEntrance shareEntrance] currentNavigationController];
    [navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Notification Methods

- (void)userSignIn
{
    [self initData];
}

- (void)userSignOut
{
    [self cleanUpPosts];
    self.wp = @"0";
    [self reloadData];
}

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
