//
//  TopicListViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TitleListViewController.h"

#import "TitleRequest.h"
#import "TitleModel.h"

#import "TitleCell.h"

@interface TitleListViewController ()

@property (nonatomic, strong) NSMutableArray<TitleModel> *titles;

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
    
    [self initData];
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
    
    UIImage *searchImage = [UIImage imageNamed:@"icon_nav_search"];
    UIButton *searchButton = [UIButton leftBarButtonWithImage:searchImage highlightedImage:searchImage target:self action:@selector(handleSearchButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setLeftBarButton:searchButton];
    
    UIImage *addImage = [UIImage imageNamed:@"icon_nav_add"];
    UIButton *addTopicButton = [UIButton rightBarButtonWithImage:addImage highlightedImage:addImage target:self action:@selector(handleAddTopicButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:addTopicButton];
    
}

#pragma mark - Private Methods

- (void)initData
{
    self.loadingType = LoadingTypeInit;
    
    self.titles = [NSMutableArray<TitleModel> array];
    
    [self loadData];
}

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
    
    [TitleRequest getTopicsWithParams:params success:^(TitleListResultModel *resultModel) {
        
        strongify(self);
        
        self.tableView.showsPullToRefresh = YES;
        
        if (resultModel) {
            
            if ( LoadingTypeLoadMore == self.loadingType ) {
                [self finishLoadMore];
            } else {
                [self finishRefresh];
                [self.titles removeAllObjects];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleModel *topic = [self.titles safeObjectAtIndex:indexPath.row];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleModel *topic = [self.titles safeObjectAtIndex:indexPath.row];
    
    CGFloat height = 0;
    
    if ( topic ) {
        
        height = [TitleCell heightForCell:topic];
        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TitleModel *topic = [self.titles safeObjectAtIndex:indexPath.row];
    
    if ( topic ) {
        DBG(@"Post:%@ Click", topic.id);
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
}

- (void)handleSearchButton
{
    DBG(@"handleSearchButton");
}

@end
