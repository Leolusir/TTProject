//
//  SignInUpViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "SignInUpViewController.h"

@interface SignInUpViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *signInButton;

@end

@implementation SignInUpViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self render];
    
}

#pragma mark - Private Methods

- (void)render
{
    
    // 背景
    self.backgroundImageView  = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.backgroundImageView.image = [UIImage imageNamed:@"lanuch2"];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    // 登录按钮
    self.signInButton = [UIButton buttonWithTitle:@"登录" font:FONT(20) color:Color_White highlightedColor:Color_White target:self action:@selector(showSignInView) forControlEvents:UIControlEventTouchUpInside];
    self.signInButton.bottom = SCREEN_HEIGHT - 16;
    self.signInButton.centerX = SCREEN_WIDTH / 4;
    [self.view addSubview:self.signInButton];
    
    // 注册按钮
    self.signUpButton = [UIButton buttonWithTitle:@"注册" font:FONT(20) color:Color_White highlightedColor:Color_White target:self action:@selector(showSignUpView) forControlEvents:UIControlEventTouchUpInside];
    self.signUpButton.bottom = SCREEN_HEIGHT - 16;
    self.signUpButton.centerX = SCREEN_WIDTH / 4 * 3;
    [self.view addSubview:self.signUpButton];
    
}

#pragma mark - Event Response

- (void)showSignInView
{
    DBG(@"showSignInView");
}

- (void)showSignUpView
{
    DBG(@"showSignUpView");
}

@end
