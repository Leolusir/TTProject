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

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIButton *myPostButton;
@property (nonatomic, strong) UIButton *myTitleButton;
@property (nonatomic, strong) UIButton *settingButton;

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
    
    [self render];
}

#pragma mark - Private Methods

- (void)render
{

    [self.view addSubview:self.backgroundView];
    
    UIImage *avatarImage = [UIImage imageNamed:[@"m" isEqualToString:[TTUserService sharedService].gender] ? @"seek_boy" : @"seek_girl"];
    self.avatarImageView.image = avatarImage;
    [self.backgroundView addSubview:self.avatarImageView];
    
    CGFloat padding = 20;
    if ( IS_IPHONE4 || IS_IPHONE5 ) {
        padding = 5;
    }
    CGFloat margin = ( SCREEN_WIDTH - 100 * 3 - padding * 2 ) / 2;
    
    self.myPostButton.left = margin;
    self.myTitleButton.left = self.myPostButton.right + padding;
    self.settingButton.left = self.myTitleButton.right + padding;
    
    self.myPostButton.top = self.backgroundView.bottom + 20;
    self.myTitleButton.top = self.myPostButton.top;
    self.settingButton.top = self.myPostButton.top;
    
    [self.view addSubview:self.myPostButton];
    [self.view addSubview:self.myTitleButton];
    [self.view addSubview:self.settingButton];
    
}

#pragma mark - Getters And Setters

- (UIView *)backgroundView
{
    if ( !_backgroundView ) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, 200)];
        _backgroundView.backgroundColor = Color_Green1;
    }
    return _backgroundView;
}

- (UIImageView *)avatarImageView
{
    if ( !_avatarImageView ) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _avatarImageView.centerX = SCREEN_WIDTH / 2;
        _avatarImageView.centerY = 100;
    }
    
    return _avatarImageView;
}

- (UIButton *)myPostButton
{
    if ( !_myPostButton ) {
        _myPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myPostButton setExclusiveTouch:YES];
        _myPostButton.backgroundColor = Color_White;
        _myPostButton.titleLabel.font = FONT(14);
        [_myPostButton setTitle:@"我的动态" forState:UIControlStateNormal];
        [_myPostButton setTitleColor:Color_Gray2 forState:UIControlStateNormal];
        [_myPostButton setImage:[UIImage imageNamed:@"icon_me_my_post"] forState:UIControlStateNormal];
        [_myPostButton setImage:[UIImage imageNamed:@"icon_me_my_post"] forState:UIControlStateHighlighted];
        _myPostButton.width = 100;
        _myPostButton.height = 100;
        _myPostButton.imageEdgeInsets = UIEdgeInsetsMake(-35, 0, 0, -55);
        _myPostButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, -40, 0);
        [_myPostButton addTarget:self action:@selector(handleMyPostButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myPostButton;
}

- (UIButton *)myTitleButton
{
    if ( !_myTitleButton ) {
        _myTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myTitleButton setExclusiveTouch:YES];
        _myTitleButton.backgroundColor = Color_White;
        _myTitleButton.titleLabel.font = FONT(14);
        [_myTitleButton setTitle:@"我的话题" forState:UIControlStateNormal];
        [_myTitleButton setTitleColor:Color_Gray2 forState:UIControlStateNormal];
        [_myTitleButton setImage:[UIImage imageNamed:@"icon_me_my_title"] forState:UIControlStateNormal];
        [_myTitleButton setImage:[UIImage imageNamed:@"icon_me_my_title"] forState:UIControlStateHighlighted];
        _myTitleButton.width = 100;
        _myTitleButton.height = 100;
        _myTitleButton.imageEdgeInsets = UIEdgeInsetsMake(-35, 0, 0, -55);
        _myTitleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, -40, 0);
        [_myTitleButton addTarget:self action:@selector(handleMyTitleButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myTitleButton;
}

- (UIButton *)settingButton
{
    if ( !_settingButton ) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setExclusiveTouch:YES];
        _settingButton.backgroundColor = Color_White;
        _settingButton.titleLabel.font = FONT(14);
        [_settingButton setTitle:@"相关设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:Color_Gray2 forState:UIControlStateNormal];
        [_settingButton setImage:[UIImage imageNamed:@"icon_me_setting"] forState:UIControlStateNormal];
        [_settingButton setImage:[UIImage imageNamed:@"icon_me_setting"] forState:UIControlStateHighlighted];
        _settingButton.width = 100;
        _settingButton.height = 100;
        _settingButton.imageEdgeInsets = UIEdgeInsetsMake(-35, 0, 0, -55);
        _settingButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, -40, 0);
        [_settingButton addTarget:self action:@selector(handleSettingButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

#pragma mark - Event Response

- (void)handleSettingButton
{
    DBG(@"handleSettingButton");
    [[TTNavigationService sharedService] openUrl:@"jump://setting"];
}

- (void)handleMyPostButton
{
    DBG(@"handleMyPostButton");
    [[TTNavigationService sharedService] openUrl:@"jump://my_post"];
}

- (void)handleMyTitleButton
{
    DBG(@"handleMyTitleButton");
    [[TTNavigationService sharedService] openUrl:@"jump://my_title"];
}

@end
