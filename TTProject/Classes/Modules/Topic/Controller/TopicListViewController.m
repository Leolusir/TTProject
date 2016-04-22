//
//  TopicListViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TopicListViewController.h"

#import "TopicRequest.h"
#import "TopicModel.h"

#import "TopicCell.h"

@interface TopicListViewController ()

@property (nonatomic, strong) NSMutableArray<TopicModel> *titles;

@end

@implementation TopicListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
}

#pragma mark - Override Methods

- (void)addTableView
{
    [super addTableView];
    
    self.tableView.top = NAVBAR_HEIGHT;
    self.tableView.height = SCREEN_HEIGHT - NAVBAR_HEIGHT - TABBAR_HEIGHT;
    
}

#pragma mark - Private Methods

- (void)initData
{
    self.loadingType = LoadingTypeInit;
    
    self.titles = [NSMutableArray<TopicModel> array];
    
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
    
    [TopicRequest getTopicsWithParams:params success:^(TopicListResultModel *resultModel) {
        
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
    TopicModel *topic = [self.titles safeObjectAtIndex:indexPath.row];
    
    if (topic) {
        
        TopicCell *cell = [TopicCell dequeueReusableCellForTableView:tableView];
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
    TopicModel *topic = [self.titles safeObjectAtIndex:indexPath.row];
    
    CGFloat height = 0;
    
    if ( topic ) {
        
        height = [TopicCell heightForCell:topic];
        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicModel *topic = [self.titles safeObjectAtIndex:indexPath.row];
    
    if ( topic ) {
        DBG(@"Post:%@ Click", topic.id);
    }
}

#pragma mark - TTErrorTipsViewDelegate

- (void) errorTipsViewBeginRefresh:(TTErrorTipsView *)tipsView
{
    [self initData];
}

@end
