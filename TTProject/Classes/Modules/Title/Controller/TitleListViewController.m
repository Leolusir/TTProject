//
//  TopicListViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TitleListViewController.h"
#import "TitleAddViewController.h"
#import "TitleRequest.h"
#import "TitleModel.h"

#import "TitleCell.h"

#import <YYText/YYText.h>

@interface TitleListViewController ()

@property (nonatomic, strong) NSMutableArray<TitleModel> *titles;
@property (nonatomic, strong) NSMutableArray<TitleModel> *hotTitles;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, strong) NSString *country;

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
    
    [self loadData];
}

- (void)loadData
{
    if (![TTUserService sharedService].isLogin) {
        return;
    }
    
    if ( LoadingTypeLoadMore != self.loadingType ) {
        
        weakify(self);
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            
            strongify(self);
            
            if (error)
            {
                // TODO: 错误消息待优化
                [self showAlert:@"定位失败！"];
                DBG(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
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
            }
            
            [self.titles addObjectsFromArray:resultModel.titles];
            
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
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YYLabel *headerLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    NSString *title = @"";
    if ( 0 == section ) {
        title = @"最热话题";
    } else {
        title = @"最新话题";
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
