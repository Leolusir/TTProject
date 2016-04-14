//
//  SignInUpViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "SignInUpViewController.h"

@interface SignInUpViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *signInButton;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *formBgView;

@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIView *phoneTextFieldBottomLine;
@property (nonatomic, strong) UITextField *captchaTextField;
@property (nonatomic, strong) UIView *captchaTextFieldBottomLine;
@property (nonatomic, strong) UIImageView *maleImageView;
@property (nonatomic, strong) UIImageView *femaleImageView;
@property (nonatomic, strong) UIPickerView *datePickerView;
@property (nonatomic, strong) UIButton *captchaButton;
@property (nonatomic, strong) UIButton *doSignInButton;
@property (nonatomic, strong) UIButton *doSignUpButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *captcha;
@property (nonatomic, strong) NSString *birthYear;
@property (nonatomic, strong) NSString *birthMonth;
@property (nonatomic, strong) NSString *birthDay;
@property (nonatomic, strong) NSString *gender;

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
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.signInButton];
    [self.view addSubview:self.signUpButton];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.formBgView];
}

#pragma mark - Getters And Setters

- (UIImageView *)backgroundImageView
{
    if ( !_backgroundImageView ) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        _backgroundImageView.image = [UIImage imageNamed:@"lanuch2"];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _backgroundImageView;
}

- (UIButton *)signInButton
{
    if ( !_signInButton ) {
        _signInButton = [UIButton buttonWithTitle:@"登录" font:FONT(20) color:Color_White highlightedColor:Color_White target:self action:@selector(showSignInView) forControlEvents:UIControlEventTouchUpInside];
        _signInButton.bottom = SCREEN_HEIGHT - 16;
        _signInButton.centerX = SCREEN_WIDTH / 4;
    }
    
    return _signInButton;
}

- (UIButton *)signUpButton
{
    if ( !_signUpButton ) {
        _signUpButton = [UIButton buttonWithTitle:@"注册" font:FONT(20) color:Color_White highlightedColor:Color_White target:self action:@selector(showSignUpView) forControlEvents:UIControlEventTouchUpInside];
        _signUpButton.bottom = SCREEN_HEIGHT - 16;
        _signUpButton.centerX = SCREEN_WIDTH / 4 * 3;
    }
    
    return _signUpButton;
}

- (UIView *)maskView
{
    if ( !_maskView ) {
        _maskView = [[UIView alloc] initWithFrame:self.view.frame];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.4f);
        _maskView.hidden = YES;
        _maskView.userInteractionEnabled = YES;
        _maskView.opaque = NO;
        [_maskView bk_whenTapped:^{
            self.maskView.hidden = YES;
            self.formBgView.hidden = YES;
        }];
    }
    
    return _maskView;
}

- (UIView *)formBgView
{
    if ( !_formBgView ) {
        _formBgView = [[UIView alloc] initWithFrame:CGRectMake(20, 165, SCREEN_WIDTH - 20 * 2, 225)];
        _formBgView.backgroundColor = Color_White;
        _formBgView.layer.cornerRadius = 5;
        _formBgView.hidden = YES;
    }
    
    return _formBgView;
}

#pragma mark - Event Response

- (void)showSignInView
{
    DBG(@"showSignInView");
    self.maskView.hidden = NO;
    self.formBgView.hidden = NO;
    [self.formBgView removeAllSubviews];
    
}

- (void)showSignUpView
{
    DBG(@"showSignUpView");
    self.maskView.hidden = NO;
    self.formBgView.hidden = NO;
    [self.formBgView removeAllSubviews];
}

#pragma mark - UITextFieldDelegate
#pragma mark - UIPickerViewDelegate
#pragma mark - UIPickerViewDataSource

@end
