//
//  SignInUpViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "SignInUpViewController.h"
#import "TTMDTextField.h"
#import "UserRequest.h"

@interface SignInUpViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *signInButton;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *formBgView;

@property (nonatomic, strong) TTMDTextField *phoneTextField;
@property (nonatomic, strong) TTMDTextField *captchaTextField;
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

@property (nonatomic, assign) BOOL isSignIn;

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

- (void)addSignInComponentToForm
{
    [self.formBgView addSubview:self.phoneTextField];
    [self.formBgView addSubview:self.captchaTextField];
    [self.formBgView addSubview:self.captchaButton];
    [self.formBgView addSubview:self.doSignInButton];
}

-(NSInteger)getCaptchaType
{
    return self.isSignIn ? 1 : 0;
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

- (TTMDTextField *)phoneTextField
{
    if ( !_phoneTextField ) {
        _phoneTextField = [[TTMDTextField alloc] initWithFrame:CGRectMake(30, 30, 275, 40) normalColor:Color_Green1 errorColor:Color_Red1 disabledColor:Color_Gray1 textColor:Color_Gray2 placeholderTextColor:Color_Gray3 titleFontSize:10 textFontSize:14];
        _phoneTextField.placeholder = @"手机号";
    }
    
    return _phoneTextField;
}

- (TTMDTextField *)captchaTextField
{
    if ( !_captchaTextField ) {
        _captchaTextField = [[TTMDTextField alloc] initWithFrame:CGRectMake(30, self.phoneTextField.bottom + 30, 180, 40) normalColor:Color_Green1 errorColor:Color_Red1 disabledColor:Color_Gray1 textColor:Color_Gray2 placeholderTextColor:Color_Gray3 titleFontSize:10 textFontSize:14];
        _captchaTextField.placeholder = @"验证码";
    }
    
    return _captchaTextField;
}

- (UIButton *)captchaButton
{
    if ( !_captchaButton ) {
        _captchaButton = [UIButton buttonWithTitle:@"发送验证码" font:FONT(16) color:Color_Gray2 highlightedColor:Color_Gray2 target:self action:@selector(getCaptcha) forControlEvents:UIControlEventTouchUpInside];
        _captchaButton.right = self.formBgView.width - 30;
        _captchaButton.centerY = self.captchaTextField.centerY;
    }
    
    return _captchaButton;
}

- (UIButton *)doSignInButton
{
    if ( !_doSignInButton ) {
        _doSignInButton = [UIButton buttonWithTitle:@"登录" font:FONT(18) color:Color_Green1 highlightedColor:Color_Green1 target:self action:@selector(doSignIn) forControlEvents:UIControlEventTouchUpInside];
        _doSignInButton.right = self.formBgView.width - 30;
        _doSignInButton.bottom = self.formBgView.height - 10;
    }
    
    return _doSignInButton;
}

#pragma mark - Event Response

- (void)showSignInView
{
    DBG(@"showSignInView");
    self.maskView.hidden = NO;
    self.formBgView.hidden = NO;
    self.isSignIn = YES;
    [self.formBgView removeAllSubviews];
    [self addSignInComponentToForm];
    
}

- (void)showSignUpView
{
    DBG(@"showSignUpView");
    self.maskView.hidden = NO;
    self.formBgView.hidden = NO;
    self.isSignIn = NO;
    [self.formBgView removeAllSubviews];
}

- (void)doSignIn
{
    DBG(@"doSignIn %@ %@", self.phoneTextField.text, self.captchaTextField.text);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setSafeObject:[self.phoneTextField.text trim] forKey:@"phone"];
    [params setSafeObject:self.captchaTextField.text forKey:@"verCode"];
    
    weakify(self);
    
    [UserRequest loginWithParams:params success:^(SignInResultModel *resultModel) {
        
        strongify(self);
        
        [[TTUserService sharedService] saveUserInfo:resultModel.user token:resultModel.token];
        
        [self showNotice:@"登录成功"];
        
        [self bk_performBlock:^(id obj) {
            [[TTNavigationService sharedService] openUrl:@"jump://discover"];
        } afterDelay:1.f];
        
    } failure:^(StatusModel *status) {
        
        if( status ) {
            strongify(self);
            [self showNotice:status.msg];
        } else {
            [self showNotice:@"登录失败"];
        }
        
    }];
}

- (void)getCaptcha
{
    DBG(@"getCaptcha");
    
    NSString *phoneText = self.phoneTextField.text;
    
    if ( IsEmptyString(phoneText)) {
        
        [self showAlert:@"请输入手机号"];
        
        return;
    }
    
    NSDictionary *params = @{@"phone":phoneText,@"type":[NSString stringWithFormat:@"%ld", [self getCaptchaType]]};
    
    weakify(self);
    [UserRequest getCaptchaWithParams:params success:^{
        
        strongify(self);
        
        self.captchaButton.enabled = NO;
        self.time = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        [self.timer fire];
        
    } failure:^(StatusModel *status) {
        
        [self showAlert:status.msg];
        
    }];
}

- (void)handleTimer
{
    if (self.time <= 1) {
        [self.timer invalidate];
        self.captchaButton.enabled = YES;
        [_captchaButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        return;
    }
    
    [self.captchaButton setTitle:[NSString stringWithFormat:@"%lds", (long)self.time] forState:UIControlStateDisabled];
    self.time--;
}

#pragma mark - UITextFieldDelegate
#pragma mark - UIPickerViewDelegate
#pragma mark - UIPickerViewDataSource

@end
