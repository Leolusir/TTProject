//
//  MyTitleViewController.m
//  TTProject
//
//  Created by Ivan on 16/5/4.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "MyTitleViewController.h"
#import "TTActivityIndicatorView.h"

#import "MeRequest.h"
#import "TitleModel.h"
#import "TitleCell.h"

@interface MyTitleViewController ()

@property (nonatomic, strong) NSMutableArray<TitleModel> *titles;

@end

@implementation MyTitleViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的话题";
    
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:[TTUserService sharedService].id forKey:@"userId"];
    
    if ( LoadingTypeLoadMore == self.loadingType ) {
        [params setSafeObject:self.wp forKey:@"wp"];
    } else {
        [params setSafeObject:@"0" forKey:@"wp"];
    }
    
    if ( LoadingTypeInit == self.loadingType ) {
        self.tableView.showsPullToRefresh = YES;
        [TTActivityIndicatorView showInView:self.view animated:YES];
    }
    
    weakify(self);
    
    [MeRequest getMyTitlesWithParams:params success:^(TitleListResultModel *resultModel) {
        
        strongify(self);
        
        self.tableView.showsPullToRefresh = YES;
        
        if (resultModel) {
            
            if ( LoadingTypeLoadMore == self.loadingType ) {
                [self finishLoadMore];
            } else {
                [self finishRefresh];
                [self.titles removeAllObjects];
                
                if ( !resultModel.titles || resultModel.titles.count == 0 ) {
                    [self showEmptyTips:@"还没有发过话题" ownerView:self.tableView];
                }
                
                if ( LoadingTypeInit == self.loadingType ) {
                    [TTActivityIndicatorView hideActivityIndicatorForView:self.view animated:YES];
                }
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
    
    CGFloat height = 0;
    
    TitleModel *topic = [self.titles safeObjectAtIndex:indexPath.row];
    
    if ( topic ) {
        
        height = [TitleCell heightForCell:topic];
        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TitleModel *topic = [self.titles safeObjectAtIndex:indexPath.row];
    
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
}


@end
