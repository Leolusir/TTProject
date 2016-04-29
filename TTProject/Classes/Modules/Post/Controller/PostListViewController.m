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

@interface PostListViewController ()

@property (nonatomic, strong) NSMutableDictionary *textCellHeightCache;
@property (nonatomic, strong) NSMutableDictionary *postIds;
@property (nonatomic, strong) NSMutableArray<PostModel> *posts;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, strong) NSString *country;

@end

@implementation PostListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initAMap];
    
    [self initData];
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

    if ( LoadingTypeLoadMore != self.loadingType && self.needLocation) {
        
        weakify(self);
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            
            strongify(self);
            
            if (error)
            {
                // TODO: 错误消息待优化
                [self showAlert:@"定位失败！"];
                DBG(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//                return;
                
            }
            
            DBG(@"location:%@", location);
            
            self.latitude = location.coordinate.latitude;
            self.longitude = location.coordinate.longitude;
            // TODO: 去除测试数据
//            self.latitude = 30.274818;//location.coordinate.latitude;
//            self.longitude = 120.121806;//location.coordinate.longitude;
            
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
        height = [PostTextCell heightForCell:post];
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
    
    [self loadData];
}

- (void)addPosts:(NSArray *)posts
{
    for (PostModel *post in posts) {
        
        if (![self.postIds objectForKey:post.id]) {
            
            [self.posts addSafeObject:post];
            [self.postIds setSafeObject:post.id forKey:post.id];
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
    return self.posts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostModel *post = [self.posts safeObjectAtIndex:indexPath.section];

    if (post) {

        if ( 0 == indexPath.row ) {

            PostImageCell *cell = [PostImageCell dequeueReusableCellForTableView:tableView];
            cell.cellData = post.imageUrl;
            [cell reloadData];
            return cell;

        } else if ( 1 == indexPath.row) {

            PostTextCell *cell = [PostTextCell dequeueReusableCellForTableView:tableView];
            cell.cellData = post;
            [cell reloadData];
            return cell;

        }
    
    }

    BaseTableViewCell *cell = [BaseTableViewCell dequeueReusableCellForTableView:tableView];
    [cell reloadData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostModel *post = [self.posts safeObjectAtIndex:indexPath.section];

    CGFloat height = 0;

    if ( post ) {
        
        if ( 0 == indexPath.row ) {
            
            height = [PostImageCell heightForCell:post.imageUrl];
            
        } else if ( 1 == indexPath.row) {
            
            height = [self getTextCellHeight:post];
            
        }
        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostModel *post = [self.posts safeObjectAtIndex:indexPath.section];
    
    if ( post ) {
        DBG(@"Post:%@ Click", post.id);
        
        TTNavigationController *navigationController = [[ApplicationEntrance shareEntrance] currentNavigationController];
        PostViewController *vc = [[PostViewController alloc] init];
        vc.post = post;
        vc.postId = post.id;
        vc.userIdOne = post.userId;
        vc.userIdTwo = [TTUserService sharedService].id;
        
        [navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - TTErrorTipsViewDelegate

- (void) errorTipsViewBeginRefresh:(TTErrorTipsView *)tipsView
{
    [self initData];
}

@end
