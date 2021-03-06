//
//  PostListViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostListViewController.h"
#import "PostViewController.h"
#import "PostTextCell.h"
#import "PostImageCell.h"
#import "PostInfoCell.h"
#import "TTGalleryViewController.h"
#import "CWStatusBarNotification.h"

@interface PostListViewController ()

@property (nonatomic, strong) NSMutableDictionary *textCellHeightCache;
@property (nonatomic, strong) NSMutableDictionary *postIds;
@property (nonatomic, strong) NSMutableArray<PostModel> *posts;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) CWStatusBarNotification *notification;

@end

@implementation PostListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_Gray5;
    
    [self initAMap];
    
    [self initData];
    
    self.emptyNotice = @"周围冷冷清清";
    
    // TODO: 图片文字换个位置
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postVoteSuccess:) name:kNOTIFY_APP_POST_VOTE_SUCCESS object:nil];
}

#pragma mark - Private Methods

- (void)initAMap
{
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    // 定位超时时间，可修改，最小2s
    self.locationManager.locationTimeout = 3;
    // 逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 3;
}

- (void)loadData
{

    [self hideEmptyTips];
    
    if ( LoadingTypeInit == self.loadingType ) {
//        self.tableView.showsPullToRefresh = YES;
        [TTActivityIndicatorView showInView:self.view animated:YES];
    }
    
    if ( LoadingTypeLoadMore != self.loadingType && self.needLocation) {
        
        [self.notification displayNotificationWithMessage:@"定位中···" completion:nil];
        
        weakify(self);
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            
            strongify(self);
            
            [self.notification dismissNotification];
            
            if (error)
            {
                [self showNotice:@"定位失败!"];
                DBG(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                self.tableView.showsPullToRefresh = YES;
                [self finishRefresh];
                
                [self showEmptyTips:self.emptyNotice ownerView:self.tableView];
                [TTActivityIndicatorView hideActivityIndicatorForView:self.view animated:YES];
                
                return;
                
            }
            
            DBG(@"location:%@", location);
            
            self.latitude = location.coordinate.latitude;
            self.longitude = location.coordinate.longitude;

            if (regeocode)
            {
                DBG(@"reGeocode:%@", regeocode);
                self.country = regeocode.country;
                
            } else {
                self.country = @"中国";
            }
            
            [self requestData];
        }];
        
    } else {
        
        [self requestData];
    }
    
}

- (void) requestData
{
    
}

- (CGFloat)getTextCellHeight:(PostModel *)post
{
    
    CGFloat height = 0;
    
    if ( [self.textCellHeightCache objectForKey:post.id] ) {
        height = [[self.textCellHeightCache objectForKey:post.id] floatValue];
    } else {
        height = [PostTextCell heightForCell:@{@"post":post, @"rowLimit":@YES}];
        [self.textCellHeightCache setSafeObject:@(height) forKey:post.id];
    }
    
    return height;
}

#pragma mark - Custom Methods

- (void)initData
{
    self.loadingType = LoadingTypeInit;
    
    self.posts = [NSMutableArray<PostModel> array];
    self.textCellHeightCache = [NSMutableDictionary dictionary];
    self.postIds = [NSMutableDictionary dictionary];
    self.wp = @"0";
    self.notification = [CWStatusBarNotification new];
    self.notification.notificationLabelBackgroundColor = Color_Green1;
    self.notification.notificationLabelTextColor = Color_White;
    self.notification.notificationLabelFont = FONT(12);
    
    [self loadData];
}

- (void)addPosts:(NSArray *)posts
{
    if ( posts && posts.count > 0 ) {
        for (PostModel *post in posts) {
            
            if (![self.postIds objectForKey:post.id]) {
                
                [self.posts addSafeObject:post];
                [self.postIds setSafeObject:post.id forKey:post.id];
            }
        }
    }
    
}

- (void)insertPost:(PostModel *)post atIndex:(NSInteger)index
{
    [self.posts insertObject:post atIndex:index];
    [self.postIds setSafeObject:post.id forKey:post.id];
}

- (void)cleanUpPosts
{
    [self.posts removeAllObjects];
    [self.postIds removeAllObjects];
    [self.textCellHeightCache removeAllObjects];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.posts.count * 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 == section % 2 ) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 0 == indexPath.section % 2 ) {
        
        PostModel *post = [self.posts safeObjectAtIndex:indexPath.section / 2];
        
        if (post) {
            
            if ( 1 == indexPath.row && post.imageUrl ) {
                
                PostImageCell *cell = [PostImageCell dequeueReusableCellForTableView:tableView];
                cell.cellData = @{@"imageSrc":post.imageUrl, @"w":@(post.w), @"h":@(post.h)};
                [cell reloadData];
                return cell;
                
            } else if ( 0 == indexPath.row) {
                
                PostTextCell *cell = [PostTextCell dequeueReusableCellForTableView:tableView];
                cell.cellData = @{@"post":post, @"rowLimit":@YES};
                [cell reloadData];
                return cell;
                
            } else if ( 2 == indexPath.row ) {
                PostInfoCell *cell = [PostInfoCell dequeueReusableCellForTableView:tableView];
                cell.cellData = post;
                [cell reloadData];
                return cell;
            }
            
        }
        
    }
    

    BaseTableViewCell *cell = [BaseTableViewCell dequeueReusableCellForTableView:tableView];
    [cell reloadData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if ( 0 == indexPath.section % 2 ) {
        PostModel *post = [self.posts safeObjectAtIndex:indexPath.section / 2];
        
        if ( post ) {
            
            if ( 1 == indexPath.row && post.imageUrl ) {
                
                height = [PostImageCell heightForCell:@{@"imageSrc":post.imageUrl, @"w":@(post.w), @"h":@(post.h)}];
                
            } else if ( 0 == indexPath.row) {
                
                height = [self getTextCellHeight:post];
                
            } else if ( 2 == indexPath.row ) {
                
                height = [PostInfoCell heightForCell:post];
                
            }
            
        }
    } else {
        height = 10;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( 0 == indexPath.section % 2 ) {
        
        PostModel *post = [self.posts safeObjectAtIndex:indexPath.section / 2];
        
        if ( post ) {
            
            DBG(@"Post:%@ Click", post.id);
            
            if ( 1 == indexPath.row ) {
                
                TTGalleryViewController *galleryViewController = [[TTGalleryViewController alloc] init];
                galleryViewController.imageSrcs = @[[NSString stringWithFormat:@"%@-l",post.imageUrl]];
                [[[ApplicationEntrance shareEntrance] currentNavigationController] pushViewController:galleryViewController animated:YES];
            } else {
                PostViewController *vc = [[PostViewController alloc] init];
                vc.post = post;
                vc.postId = post.id;
                vc.userIdOne = post.userId;
                vc.userIdTwo = [TTUserService sharedService].id;
                
                TTNavigationController *navigationController = [[ApplicationEntrance shareEntrance] currentNavigationController];
                [navigationController pushViewController:vc animated:YES];
            }
        }
    }
    
}

#pragma mark - TTErrorTipsViewDelegate

- (void) errorTipsViewBeginRefresh:(TTErrorTipsView *)tipsView
{
    [self initData];
}

#pragma mark - Notification Methods

- (void)postVoteSuccess:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    NSString *postId = [userInfo objectForKey:@"postId"];
    NSInteger vote = [[userInfo objectForKey:@"vote"] integerValue];
    NSInteger voteUp = [[userInfo objectForKey:@"voteUp"] integerValue];
    NSInteger voteDown = [[userInfo objectForKey:@"voteDown"] integerValue];
    
    if ( postId && [self.postIds objectForKey:postId] ) {
        for (PostModel *post in self.posts) {
            if ( [postId isEqualToString:post.id] ) {
                post.vote = vote;
                post.voteUp = voteUp;
                post.voteDown = voteDown;
                [self reloadData];
                break;
            }
        }
    }
}

@end
