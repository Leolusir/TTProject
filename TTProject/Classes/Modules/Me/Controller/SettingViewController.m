//
//  SettingViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/29.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "SettingViewController.h"
#import "MenuItemCell.h"

@interface SettingViewController ()

@property (nonatomic, strong) NSArray *menu;

@end

@implementation SettingViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    
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

#pragma mark - Private Methods

- (void)initData
{
    self.menu = @[
                  @{@"type":@"item", @"key":@"1", @"title":@"推送开关", @"link":@"", @"line":@YES, @"arrow":@YES},
                  @{@"type":@"item", @"key":@"2", @"title":@"检查更新", @"link":@"", @"line":@YES, @"arrow":@YES},
                  @{@"type":@"item", @"key":@"3", @"title":@"关于", @"link":@"", @"line":@YES, @"arrow":@YES},
                  @{@"type":@"item", @"key":@"4", @"title":@"拉朋友一起玩", @"link":@"", @"line":@NO, @"arrow":@YES}
                  ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if ( row < self.menu.count ) {
        
        NSDictionary *itemData = [self.menu safeObjectAtIndex:row];
        
        if ( ![@"empty" isEqualToString:itemData[@"type"]]) {
            
            MenuItemCell *cell = [MenuItemCell dequeueReusableCellForTableView:tableView];
            cell.cellData = itemData;
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
    NSInteger row = indexPath.row;
    
    CGFloat height = 0;
    
    if ( row < self.menu.count ) {
        
        NSDictionary *itemData = [self.menu safeObjectAtIndex:row];
        
        if ( ![@"empty" isEqualToString:itemData[@"type"]]) {
            
            height = [MenuItemCell heightForCell:itemData];
            
        } else {
            
            height = 10;
            
        }
        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
