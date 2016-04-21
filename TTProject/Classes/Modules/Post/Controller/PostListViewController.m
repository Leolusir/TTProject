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
@property (nonatomic, strong) NSMutableArray<PostModel> *posts;

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
    self.textCellHeightCache = [NSMutableDictionary dictionary];
    self.wp = @"0";
    
    [self loadData];
}

- (void)loadData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ( LoadingTypeLoadMore == self.loadingType ) {
        
        
    } else {
        
        
    }
    
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

- (void)addPosts:(NSArray *)posts
{
    [self.posts addObjectsFromArray:posts];
}

- (void)cleanUpPosts
{
    [self.posts removeAllObjects];
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
        
        [navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - TTErrorTipsViewDelegate

- (void) errorTipsViewBeginRefresh:(TTErrorTipsView *)tipsView
{
    [self initData];
}

@end
