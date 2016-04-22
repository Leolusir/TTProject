//
//  PostViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostViewController.h"
#import "TTGalleryViewController.h"

#import "CommentModel.h"
#import "PostTextCell.h"
#import "PostImageCell.h"

@interface PostViewController ()

@property (nonatomic, strong) NSMutableDictionary *commentCellHeightCache;
@property (nonatomic, strong) NSMutableArray<CommentModel> *comments;
@property (nonatomic, assign) CGFloat postTextCellHeight;

@end

@implementation PostViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"详情";
    
    [self initData];
}

#pragma mark - Private Methods

- (void)initData
{
    self.loadingType = LoadingTypeInit;
    
    self.comments = [NSMutableArray<CommentModel> array];
    self.commentCellHeightCache = [NSMutableDictionary dictionary];
    self.wp = @"0";
    self.postTextCellHeight = 0;
    
    [self loadData];
}

- (void)loadData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ( LoadingTypeLoadMore == self.loadingType ) {
        
        
    } else {
        
        
    }
    
}

- (CGFloat)getCommentCellHeight:(CommentModel *)comment
{
    
    CGFloat height = 0;
    
    if ( [self.commentCellHeightCache objectForKey:comment.id] ) {
        height = [[self.commentCellHeightCache objectForKey:comment.id] floatValue];
    } else {
        height = 0;//[CommentCell heightForCell:comment];
        [self.commentCellHeightCache setSafeObject:@(height) forKey:comment.id];
    }
    
    return height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 == section ) {
        return 2;
    }
    
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( 0 == indexPath.section ) {
        
        if ( 0 == indexPath.row ) {
            
            PostImageCell *cell = [PostImageCell dequeueReusableCellForTableView:tableView];
            cell.cellData = self.post.imageUrl;
            [cell reloadData];
            return cell;
            
        } else if ( 1 == indexPath.row) {
            
            PostTextCell *cell = [PostTextCell dequeueReusableCellForTableView:tableView];
            cell.cellData = self.post;
            [cell reloadData];
            return cell;
            
        }
        
    } else {
    
    }
    
    BaseTableViewCell *cell = [BaseTableViewCell dequeueReusableCellForTableView:tableView];
    [cell reloadData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if ( 0 == indexPath.section ) {
        
        if ( 0 == indexPath.row ) {
            
            height = [PostImageCell heightForCell:self.post.imageUrl];
            
        } else if ( 1 == indexPath.row) {
            
            height = self.postTextCellHeight > 0 ? self.postTextCellHeight : [PostTextCell heightForCell:self.post];
            
        }
        
    } else {
        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( 0 == indexPath.section ) {
        
        if ( 0 == indexPath.row ) {
            
            TTGalleryViewController *galleryViewController = [[TTGalleryViewController alloc] init];
            galleryViewController.imageSrcs = @[self.post.imageUrl];
            [[[ApplicationEntrance shareEntrance] currentNavigationController] pushViewController:galleryViewController animated:YES];
            
        }
    }
}

#pragma mark - TTErrorTipsViewDelegate

- (void) errorTipsViewBeginRefresh:(TTErrorTipsView *)tipsView
{
    [self initData];
}

@end
