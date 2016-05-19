//
//  TopicListViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TitleListViewController.h"
#import "TitleAddViewController.h"
#import "TTActivityIndicatorView.h"
#import "TitleRequest.h"
#import "TitleModel.h"
#import "CWStatusBarNotification.h"

#import "TitleCell.h"

#import <YYText/YYText.h>

@interface TitleListViewController ()

@property (nonatomic, strong) NSMutableArray<TitleModel> *titles;
@property (nonatomic, strong) NSMutableArray<TitleModel> *hotTitles;
@property (nonatomic, strong) NSMutableDictionary *titleIds;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) CWStatusBarNotification *notification;

@end

@implementation TitleListViewController

#pragma mark - Life Cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"话题" titleColor:Color_Gray1 selectedTitleColor:Color_Green1 icon:[UIImage imageNamed:@"icon_tabbar_topic_normal"] selectedIcon:[UIImage imageNamed:@"icon_tabbar_topic_selected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"话题";
    
    [self addNavigationBar];
    
    [self initAMap];
    
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignIn) name:kNOTIFY_APP_USER_SIGNIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignOut) name:kNOTIFY_APP_USER_SIGNOUT object:nil];
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
    
//    UIImage *searchImage = [UIImage imageNamed:@"icon_nav_search"];
//    UIButton *searchButton = [UIButton leftBarButtonWithImage:searchImage highlightedImage:searchImage target:self action:@selector(handleSearchButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationBar setLeftBarButton:searchButton];
    
    UIImage *addImage = [UIImage imageNamed:@"icon_nav_add"];
    UIButton *addTopicButton = [UIButton rightBarButtonWithImage:addImage highlightedImage:addImage target:self action:@selector(handleAddTopicButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:addTopicButton];
    
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

- (void)initData
{
    self.loadingType = LoadingTypeInit;
    
    self.titles = [NSMutableArray<TitleModel> array];
    self.hotTitles = [NSMutableArray<TitleModel> array];
    self.titleIds = [NSMutableDictionary dictionary];
    
    self.notification = [CWStatusBarNotification new];
    self.notification.notificationLabelBackgroundColor = Color_Green1;
    self.notification.notificationLabelTextColor = Color_White;
    self.notification.notificationLabelFont = FONT(12);
    
    [self loadData];
}

- (void)loadData
{
    if (![TTUserService sharedService].isLogin) {
        return;
    }
    
    if ( LoadingTypeInit == self.loadingType ) {
//        self.tableView.showsPullToRefresh = YES;
        [TTActivityIndicatorView showInView:self.view animated:YES];
    }
    
    if ( LoadingTypeLoadMore != self.loadingType ) {
        
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
                
                [self showEmptyTips:@"想和周围人一起聊点什么呢" ownerView:self.tableView];
                
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

- (void)requestData
{
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
    
    [self hideEmptyTips];
    
    weakify(self);
    
    [TitleRequest getTopicsWithParams:params success:^(TitleListResultModel *resultModel) {
        
        strongify(self);
        
        self.tableView.showsPullToRefresh = YES;
        
        if (resultModel) {
            
            if ( LoadingTypeLoadMore == self.loadingType ) {
                [self finishLoadMore];
            } else {
                [self finishRefresh];
                [self.titles removeAllObjects];
                [self.hotTitles removeAllObjects];
                [self.hotTitles addObjectsFromSafeArray:resultModel.hotTitles];
                [self.titleIds removeAllObjects];
                
                if ( ( !resultModel.titles || resultModel.titles.count == 0 ) && (!resultModel.hotTitles || resultModel.hotTitles.count == 0) ) {
                    [self showEmptyTips:@"想和周围人一起聊点什么呢" ownerView:self.tableView];
                }
                
                if ( LoadingTypeInit == self.loadingType ) {
                    [TTActivityIndicatorView hideActivityIndicatorForView:self.view animated:YES];
                }
            }
            
            [self addTitles:resultModel.titles];
            
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
            
            if ( LoadingTypeInit == self.loadingType ) {
                [TTActivityIndicatorView hideActivityIndicatorForView:self.view animated:YES];
            }
        }
        
    }];
}

- (void)addTitles:(NSArray *)titles
{
    if ( titles && titles.count > 0 ) {
        for (TitleModel *title in titles) {
            if (![self.titleIds objectForKey:title.id]) {
                [self.titles addSafeObject:title];
                [self.titleIds setSafeObject:title.id forKey:title.id];
            }
        }
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 == section ) {
        return self.hotTitles.count;
    } else {
        return self.titles.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    TitleModel *topic = nil;
    
    if ( 0 == section ) {
        
        topic = [self.hotTitles safeObjectAtIndex:row];
        
    } else {
        
        topic = [self.titles safeObjectAtIndex:row];
        
    }
    
    if (topic) {
        
        TitleCell *cell = [TitleCell dequeueReusableCellForTableView:tableView];
        cell.cellData = topic;
        [cell reloadData];
        return cell;
        
    }
    
    BaseTableViewCell *cell = [BaseTableViewCell dequeueReusableCellForTableView:tableView];
    [cell reloadData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( 0 == section ) {
        if (self.hotTitles.count == 0) {
            return 0;
        }
    } else {
        if (self.titles.count == 0) {
            return 0;
        }
    }
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YYLabel *headerLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    NSString *title = @"";
    if ( 0 == section ) {
        title = @"正在热议的话题";
    } else {
        title = @"最新更新的话题";
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:title];
    attributedText.yy_font = BOLD_FONT(16);
    attributedText.yy_color = Color_Green1;
    attributedText.yy_firstLineHeadIndent = 20;
    
    headerLabel.attributedText = attributedText;
    
    [headerLabel sizeToFit];
    
    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    CGFloat height = 0;
    
    TitleModel *topic = nil;
    
    if ( 0 == section ) {
        
        topic = [self.hotTitles safeObjectAtIndex:row];
        
    } else {
        
        topic = [self.titles safeObjectAtIndex:row];
        
    }
    
    if ( topic ) {
        
        height = [TitleCell heightForCell:topic];
        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    TitleModel *topic = nil;
    
    if ( 0 == section ) {
        
        topic = [self.hotTitles safeObjectAtIndex:row];
        
    } else {
        
        topic = [self.titles safeObjectAtIndex:row];
        
    }
    
    if ( topic ) {
        
        DBG(@"Post:%@ Click", topic.id);
        [[TTNavigationService sharedService] openUrl:[NSString stringWithFormat:@"jump://title_post?title=%@", topic.id]];
        
    }
    
}

#pragma mark - TTErrorTipsViewDelegate

- (void) errorTipsViewBeginRefresh:(TTErrorTipsView *)tipsView
{
    [self initData];
}

#pragma mark - Event Response

- (void)handleAddTopicButton
{
    DBG(@"handleAddTopicButton");
    
    TitleAddViewController *vc = [[TitleAddViewController alloc] init];
    vc.callback = ^(NSString *title) {
        DBG(@"title:%@", title);
        [[TTNavigationService sharedService] openUrl:[NSString stringWithFormat:@"jump://post_publish?title=%@", title]];
    };
    
    TTNavigationController *navigationController = [[ApplicationEntrance shareEntrance] currentNavigationController];
    [navigationController pushViewController:vc animated:YES];
}

- (void)handleSearchButton
{
    DBG(@"handleSearchButton");
}

#pragma mark - Notification Methods

- (void)userSignIn
{
    [self initData];
}

- (void)userSignOut
{
    [self.titles removeAllObjects];
    [self.hotTitles removeAllObjects];
    [self reloadData];
}

@end
