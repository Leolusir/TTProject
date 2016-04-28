//
//  MeViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "MeViewController.h"
#import "UserInfoCell.h"
#import "MenuItemCell.h"

@interface MeViewController ()

@property (nonatomic, strong) NSArray *menu;

@end

@implementation MeViewController

#pragma mark - Life Cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"我的" titleColor:Color_Gray1 selectedTitleColor:Color_Green1 icon:[UIImage imageNamed:@"icon_tabbar_me_normal"] selectedIcon:[UIImage imageNamed:@"icon_tabbar_me_selected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的";
    
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

    UIImage *addImage = [UIImage imageNamed:@"icon_nav_setting"];
    UIButton *settingButton = [UIButton rightBarButtonWithImage:addImage highlightedImage:addImage target:self action:@selector(handleSettingButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:settingButton];
    
}

#pragma mark - Private Methods

- (void)initData
{
    self.menu = @[
                  @{@"type":@"empty",},
                  @{@"type":@"item", @"key":@"1", @"title":@"我发布的", @"link":@"jump://my_post", @"line":@YES, @"arrow":@YES},
                  @{@"type":@"item", @"key":@"2", @"title":@"我参与的", @"link":@"", @"line":@NO, @"arrow":@YES},
                  @{@"type":@"empty",},
                  @{@"type":@"item", @"key":@"3", @"title":@"退出", @"link":@"", @"line":@NO, @"arrow":@NO},
                  ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 == section ) {
        return 1;
    } else {
        return self.menu.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if ( 0 == section ) {
        
        UserInfoCell *cell = [UserInfoCell dequeueReusableCellForTableView:tableView];
        cell.cellData = @{@"gender":[TTUserService sharedService].gender, @"astro":@"天蝎座", @"age":[NSString stringWithFormat:@"%.2f岁", [TTUserService sharedService].age]};
        [cell reloadData];
        return cell;
        
    } else {
        
        if ( row < self.menu.count ) {
            
            NSDictionary *itemData = [self.menu safeObjectAtIndex:row];
            
            if ( ![@"empty" isEqualToString:itemData[@"type"]]) {
                
                MenuItemCell *cell = [MenuItemCell dequeueReusableCellForTableView:tableView];
                cell.cellData = itemData;
                [cell reloadData];
                return cell;
                
            }
            
        }
        
    }
    
    BaseTableViewCell *cell = [BaseTableViewCell dequeueReusableCellForTableView:tableView];
    [cell reloadData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    CGFloat height = 0;
    
    if ( 0 == section ) {
        
        height = [UserInfoCell heightForCell:nil];
        
    } else {
        
        if ( row < self.menu.count ) {
            
            NSDictionary *itemData = [self.menu safeObjectAtIndex:row];
            
            if ( ![@"empty" isEqualToString:itemData[@"type"]]) {
                
                height = [MenuItemCell heightForCell:itemData];
                
            } else {
                
                height = 10;
                
            }
            
        }
        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if ( 1 == section ) {
    
        if ( row < self.menu.count ) {
            
            NSDictionary *itemData = [self.menu safeObjectAtIndex:row];
            
            NSString *link = itemData[@"link"];
            NSString *key = itemData[@"key"];
            
            if ( !IsEmptyString(link) ) {
                
                [[TTNavigationService sharedService] openUrl:link];
                
            } else if ( !IsEmptyString(key) ) {
                
                if ( [@"3" isEqualToString:key]) {
                    
                    [[TTUserService sharedService] logout];
                    
                }
                
            }
            
        }
        
    }
    
    
}

#pragma mark - Event Response

- (void)handleSettingButton
{
    DBG(@"handleSettingButton");
    [[TTNavigationService sharedService] openUrl:@"jump://setting"];
}

@end
