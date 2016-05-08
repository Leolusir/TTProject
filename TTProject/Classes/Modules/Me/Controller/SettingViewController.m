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
    self.tableView.height = SCREEN_HEIGHT - NAVBAR_HEIGHT;
    
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
    
    self.menu = @[
                  @{@"type":@"item", @"key":@"1", @"title":@"应用名称", @"link":@"", @"line":@YES, @"arrow":@NO, @"value":@"seek"},
                  @{@"type":@"item", @"key":@"2", @"title":@"版本信息", @"link":@"", @"line":@NO, @"arrow":@NO, @"value":APP_VERSION_SHOW},
                  @{@"type":@"empty",},
                  @{@"type":@"item", @"key":@"3", @"title":@"推送开关", @"link":@"", @"line":@NO, @"arrow":@NO, @"value":pushStatus},
                  @{@"type":@"empty",},
                  @{@"type":@"item", @"key":@"4", @"title":@"Devils小队", @"link":@"", @"line":@YES, @"arrow":@NO, @"value":@"一群野生开发者"},
                  @{@"type":@"item", @"key":@"5", @"title":@"市场联系", @"link":@"", @"line":@YES, @"arrow":@NO, @"value":@"devils.team@outlook.com"},
                  @{@"type":@"item", @"key":@"6", @"title":@"意见交流", @"link":@"", @"line":@NO, @"arrow":@NO, @"value":@"QQ:3275149780"},
                  @{@"type":@"empty",},
                  @{@"type":@"item", @"key":@"7", @"title":@"退出登录", @"link":@"", @"line":@NO, @"arrow":@NO},
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
        [self showAlert:@"如果你要关闭或开启Seek的新消息推送，请在iPhone的 \"设置 - 通知\" 功能中，找到应用程序 \"seek\" 进行更改。"];
    } else if ( [@"7" isEqualToString:[itemData objectForKey:@"key"]] ) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:nil message:@"确定退出当前账户吗？" containerView:nil delegate:self confirmButtonTitle:@"确定" otherButtonTitles:@[@"取消"]];
        [alertView show];
    }
}

#pragma mark - TTAlertViewDelegate

- (void)alertView:(TTAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    DBG(@"%ld", (long)buttonIndex);
    
    if ( 0 == buttonIndex ) {
        
        DBG(@"退出");
        
        [[TTUserService sharedService] logout];
        
    }
    
}

@end
