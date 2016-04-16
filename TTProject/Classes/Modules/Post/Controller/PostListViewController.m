//
//  PostListViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostListViewController.h"
#import "PostTextCell.h"
#import "PostImageCell.h"

@interface PostListViewController ()

@end

@implementation PostListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
}

#pragma mark - Private Methods

- (void)initData
{
    self.loadingType = LoadingTypeInit;
    
    self.posts = [NSMutableArray<PostModel> array];
    
    [self loadData];
}

- (void)loadData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ( LoadingTypeLoadMore == self.loadingType ) {
        
        
    } else {
        
        
    }
    
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
            cell.cellData = post;
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
            
            height = [PostImageCell heightForCell:post];
            
        } else if ( 1 == indexPath.row) {
            
            height = [PostTextCell heightForCell:post];
            
        }
        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostModel *post = [self.posts safeObjectAtIndex:indexPath.section];
    
    if ( post ) {
        
    }
}

#pragma mark - TTErrorTipsViewDelegate

- (void) errorTipsViewBeginRefresh:(TTErrorTipsView *)tipsView
{
    [self initData];
}

@end
