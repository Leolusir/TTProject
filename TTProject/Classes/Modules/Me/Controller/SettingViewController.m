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
    
    NSString *pushStatus = @"";
    
    UIUserNotificationType notificationType;
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        notificationType = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    } else {
        notificationType = UIUserNotificationTypeNone;
    }
    
    if (notificationType == UIUserNotificationTypeNone) {
        pushStatus = @"已关闭";
    } else {
        pushStatus = @"已打开";
    }
    
    // TODO: 功能等待实装
    self.menu = @[
                  @{@"type":@"item", @"key":@"1", @"title":@"应用名称", @"link":@"", @"line":@YES, @"arrow":@NO, @"value":@"Seek"},
                  @{@"type":@"item", @"key":@"2", @"title":@"版本信息", @"link":@"", @"line":@NO, @"arrow":@NO, @"value":@"1.0.0.0 beta"},
                  @{@"type":@"empty",},
                  @{@"type":@"item", @"key":@"3", @"title":@"推送开关", @"link":@"", @"line":@NO, @"arrow":@NO, @"value":pushStatus},
                  @{@"type":@"empty",},
                  @{@"type":@"item", @"key":@"4", @"title":@"Devils小队", @"link":@"", @"line":@YES, @"arrow":@NO, @"value":@"一群野生开发者"},
                  @{@"type":@"item", @"key":@"5", @"title":@"市场联系", @"link":@"", @"line":@YES, @"arrow":@NO, @"value":@"devils.team@outlook.com"},
                  @{@"type":@"item", @"key":@"6", @"title":@"意见交流", @"link":@"", @"line":@NO, @"arrow":@NO, @"value":@"QQ:3275149780"}
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
    
    NSDictionary *itemData = [self.menu safeObjectAtIndex:indexPath.row];
    
    if ( [@"3" isEqualToString:[itemData objectForKey:@"key"]] ) {
        [self showAlert:@"如果你要关闭或开启Seek的新消息推送，请在iPhone的 \"设置 - 通知\" 功能中，找到应用程序 \"Seek\" 进行更改。"];
    }
    
}

@end
