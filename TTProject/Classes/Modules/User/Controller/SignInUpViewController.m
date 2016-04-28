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

@interface SignInUpViewController () <UIPickerViewDelegate, UIPickerViewDataSource, TTMDTextFieldDelegate>

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
@property (nonatomic, strong) UIButton *dateConfirmButton;
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
@property (nonatomic, assign) CGFloat cursorHeight;
@property (nonatomic, assign) CGFloat spacingWithKeyboardAndCursor;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSDateComponents *selectedDateComponets;

@end

@implementation SignInUpViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.calendar = [NSCalendar currentCalendar];
    self.startDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.endDate = [NSDate dateWithTimeIntervalSince1970:1451577600];
    self.selectedDateComponets = [[NSDateComponents alloc] init];
    self.selectedDateComponets.calendar = self.calendar;
    self.selectedDateComponets.year = 1970;
    self.selectedDateComponets.month = 1;
    self.selectedDateComponets.day = 1;
    
    [self render];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
    [self.formBgView removeAllSubviews];
    [self.formBgView addSubview:self.phoneTextField];
    [self.formBgView addSubview:self.captchaTextField];
    [self.formBgView addSubview:self.captchaButton];
    [self.formBgView addSubview:self.doSignInButton];
    self.phoneTextField.text = @"";
    self.captchaTextField.text = @"";
    self.captchaButton.enabled = YES;
    [self.captchaButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    
}

- (void)addSignUpComponentToFormStep1
{
    [self.formBgView removeAllSubviews];
    [self.formBgView addSubview:self.maleImageView];
    [self.formBgView addSubview:self.femaleImageView];
}

- (void)addSignUpComponentToFormStep2
{
    [self.formBgView removeAllSubviews];
    [self.formBgView addSubview:self.datePickerView];
    [self.formBgView addSubview:self.dateConfirmButton];
    
    ((UIView *)[self.datePickerView.subviews objectAtIndex:1]).hidden = YES;
    ((UIView *)[self.datePickerView.subviews objectAtIndex:2]).hidden = YES;

}

- (void)addSignUpComponentToFormStep3
{
    [self.formBgView removeAllSubviews];
    [self.formBgView addSubview:self.phoneTextField];
    [self.formBgView addSubview:self.captchaTextField];
    [self.formBgView addSubview:self.captchaButton];
    [self.formBgView addSubview:self.doSignUpButton];
    self.phoneTextField.text = @"";
    self.captchaTextField.text = @"";
    self.captchaButton.enabled = YES;
    [self.captchaButton setTitle:@"发送验证码" forState:UIControlStateNormal];
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
        weakify(self);
        [_maskView bk_whenTapped:^{
            strongify(self);
            self.maskView.hidden = YES;
            self.formBgView.hidden = YES;
            [self.view endEditing:YES];
        }];
    }
    
    return _maskView;
}

- (UIView *)formBgView
{
    if ( !_formBgView ) {
        _formBgView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 20 * 2, 225)];
        _formBgView.backgroundColor = Color_White;
        _formBgView.layer.cornerRadius = 5;
        _formBgView.hidden = YES;
        _formBgView.centerY = SCREEN_HEIGHT / 2;
        weakify(self);
        [_formBgView bk_whenTapped:^{
            strongify(self);
            [self.view endEditing:YES];
        }];
    }
    
    return _formBgView;
}

- (TTMDTextField *)phoneTextField
{
    if ( !_phoneTextField ) {
        _phoneTextField = [[TTMDTextField alloc] initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH - 100, 40) normalColor:Color_Green1 errorColor:Color_Red1 disabledColor:Color_Gray1 textColor:Color_Gray2 placeholderTextColor:Color_Gray3 titleFontSize:10 textFontSize:14];
        _phoneTextField.placeholder = @"手机号";
        _phoneTextField.delegate = self;
    }
    
    return _phoneTextField;
}

- (TTMDTextField *)captchaTextField
{
    if ( !_captchaTextField ) {
        _captchaTextField = [[TTMDTextField alloc] initWithFrame:CGRectMake(30, self.phoneTextField.bottom + 30, SCREEN_WIDTH - 200, 40) normalColor:Color_Green1 errorColor:Color_Red1 disabledColor:Color_Gray1 textColor:Color_Gray2 placeholderTextColor:Color_Gray3 titleFontSize:10 textFontSize:14];
        _captchaTextField.placeholder = @"验证码";
        _captchaTextField.delegate = self;
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

- (UIButton *)doSignUpButton
{
    if ( !_doSignUpButton ) {
        _doSignUpButton = [UIButton buttonWithTitle:@"注册" font:FONT(18) color:Color_Green1 highlightedColor:Color_Green1 target:self action:@selector(doSignUp) forControlEvents:UIControlEventTouchUpInside];
        _doSignUpButton.right = self.formBgView.width - 30;
        _doSignUpButton.bottom = self.formBgView.height - 10;
    }
    
    return _doSignUpButton;
}

- (UIImageView *)maleImageView {
    
    if ( !_maleImageView ) {
        _maleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_signup_boy"]];
        _maleImageView.centerY = self.formBgView.height / 2;
        _maleImageView.centerX = 10 + ( self.formBgView.width - 20 ) / 4;
        _maleImageView.userInteractionEnabled = YES;
        weakify(self);
        [_maleImageView bk_whenTapped:^{
            strongify(self);
            self.gender = @"m";
            [self addSignUpComponentToFormStep2];
        }];
    }
    return _maleImageView;
}

- (UIImageView *)femaleImageView {
    
    if ( !_femaleImageView ) {
        _femaleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_signup_girl"]];
        _femaleImageView.centerY = self.formBgView.height / 2;
        _femaleImageView.centerX = 10 + ( self.formBgView.width - 20 ) / 4 * 3;
        _femaleImageView.userInteractionEnabled = YES;
        weakify(self);
        [_femaleImageView bk_whenTapped:^{
            strongify(self);
            self.gender = @"f";
            [self addSignUpComponentToFormStep2];
        }];
    }
    return _femaleImageView;
}

- (UIPickerView *)datePickerView
{
    if ( !_datePickerView ) {
        _datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.formBgView.width - 20, 150)];
        _datePickerView.delegate = self;
        _datePickerView.dataSource = self;
        _datePickerView.centerX = self.formBgView.width / 2;
        _datePickerView.centerY = self.formBgView.height / 2 - 20;
    }
    return _datePickerView;
}

- (UIButton *)dateConfirmButton
{
    if ( !_dateConfirmButton ) {
        _dateConfirmButton = [UIButton buttonWithTitle:@"确定" font:FONT(18) color:Color_Green1 highlightedColor:Color_Green1 target:self action:@selector(dateConfirm) forControlEvents:UIControlEventTouchUpInside];
        _dateConfirmButton.right = self.formBgView.width - 30;
        _dateConfirmButton.bottom = self.formBgView.height - 10;
    }
    
    return _dateConfirmButton;
}

#pragma mark - Event Response

- (void)showSignInView
{
    DBG(@"showSignInView");
    self.maskView.hidden = NO;
    self.formBgView.hidden = NO;
    self.isSignIn = YES;
    [self addSignInComponentToForm];
    
}

- (void)showSignUpView
{
    DBG(@"showSignUpView");
    self.maskView.hidden = NO;
    self.formBgView.hidden = NO;
    self.isSignIn = NO;
    [self addSignUpComponentToFormStep1];
}

- (void)dateConfirm
{
    DBG(@"dateConfirm: %@ %ld", self.selectedDateComponets, self.datePickerView.subviews.count);
    
    self.birthYear = [NSString stringWithFormat:@"%ld", self.selectedDateComponets.year];
    self.birthMonth = [NSString stringWithFormat:@"%ld", self.selectedDateComponets.month];
    self.birthDay = [NSString stringWithFormat:@"%ld", self.selectedDateComponets.day];
    
    [self addSignUpComponentToFormStep3];
}

- (void)doSignIn
{
    DBG(@"doSignIn %@ %@", self.phoneTextField.text, self.captchaTextField.text);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setSafeObject:[self.phoneTextField.text trim] forKey:@"phone"];
    [params setSafeObject:self.captchaTextField.text forKey:@"verCode"];
    
    weakify(self);
    
    [UserRequest signInWithParams:params success:^(SignInUpResultModel *resultModel) {
        
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

- (void)doSignUp
{
    DBG(@"doSignUp %@ %@", self.phoneTextField.text, self.captchaTextField.text);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setSafeObject:[self.phoneTextField.text trim] forKey:@"phone"];
    [params setSafeObject:self.captchaTextField.text forKey:@"verCode"];
    [params setSafeObject:self.birthYear forKey:@"birthYear"];
    [params setSafeObject:self.birthMonth forKey:@"birthMonth"];
    [params setSafeObject:self.birthDay forKey:@"birthDay"];
    [params setSafeObject:self.gender forKey:@"gender"];
    
    weakify(self);
    
    [UserRequest signUpWithParams:params success:^(SignInUpResultModel *resultModel) {
        
        strongify(self);
        
        [[TTUserService sharedService] saveUserInfo:resultModel.user token:resultModel.token];
        
        [self showNotice:@"注册成功"];
        
        [self bk_performBlock:^(id obj) {
            [[TTNavigationService sharedService] openUrl:@"jump://discover"];
        } afterDelay:1.f];
        
    } failure:^(StatusModel *status) {
        
        if( status ) {
            strongify(self);
            [self showNotice:status.msg];
        } else {
            [self showNotice:@"注册失败"];
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
    
    NSDictionary *params = @{@"phone":phoneText,@"type":[NSString stringWithFormat:@"%ld", (long)[self getCaptchaType]]};
    
    self.captchaButton.enabled = NO;
    [self.captchaButton setTitle:@"60s" forState:UIControlStateDisabled];
    
    weakify(self);
    
    [UserRequest getCaptchaWithParams:params success:^{
        
        strongify(self);
        
        self.time = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        [self.timer fire];
        
    } failure:^(StatusModel *status) {
        
        strongify(self);
        
        self.captchaButton.enabled = YES;
        [self.captchaButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self showNotice:status.msg];
        
    }];
}

- (void)handleTimer
{
    if (self.time <= 1) {
        [self.timer invalidate];
        self.captchaButton.enabled = YES;
        [self.captchaButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        return;
    }
    
    [self.captchaButton setTitle:[NSString stringWithFormat:@"%lds", (long)self.time] forState:UIControlStateDisabled];
    self.time--;
}

#pragma mark - TTMDTextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.phoneTextField]) {
        self.cursorHeight = self.view.height - self.formBgView.top - textField.bottom;
    } else if ([textField isEqual:self.captchaTextField]) {
        self.cursorHeight = self.view.height - self.formBgView.top - textField.bottom;
    }
    
    return YES;
}

#pragma mark - Observing Methods

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)notification {
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    self.spacingWithKeyboardAndCursor = keyboardHeight - self.cursorHeight;
    if (self.spacingWithKeyboardAndCursor > 0) {
        weakify(self);
        [UIView animateWithDuration:0.2f animations:^{
            //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
            strongify(self);
            self.view.frame = CGRectMake(0.0f, -(self.spacingWithKeyboardAndCursor + 5.0f), self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.spacingWithKeyboardAndCursor > 0) {
        weakify(self);
        [UIView animateWithDuration:0.2f animations:^{
            strongify(self);
            //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
            self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) { // component是栏目index，从0开始，后面的row也一样是从0开始
        case 0: { // 第一栏为年，这里startDate和endDate为起始时间和截止时间，请自行指定
            NSDateComponents *startCpts = [self.calendar components:NSCalendarUnitYear
                                                           fromDate:self.startDate];
            NSDateComponents *endCpts = [self.calendar components:NSCalendarUnitYear
                                                         fromDate:self.endDate];
            return [endCpts year] - [startCpts year] + 1;
        }
        case 1: // 第二栏为月份
            return 12;
        case 2: { // 第三栏为对应月份的天数
            NSRange dayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                   inUnit:NSCalendarUnitMonth
                                                  forDate:[self.selectedDateComponets date]];
            return dayRange.length;
        }
        default:
            return 0;
    }
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
        [dateLabel setFont:FONT(24)];
        [dateLabel setTextColor:Color_Green1];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    switch (component) {
        case 0: {
            NSDateComponents *components = [self.calendar components:NSCalendarUnitYear
                                                            fromDate:self.startDate];
            NSString *currentYear = [NSString stringWithFormat:@"%ld", [components year] + row];
            [dateLabel setText:currentYear];
            dateLabel.textAlignment = NSTextAlignmentRight;
            break;
        }
        case 1: {
            // 返回月份可以用DateFormatter，这样可以支持本地化
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            formatter.locale = [NSLocale currentLocale];
//            NSArray *monthSymbols = [formatter monthSymbols];
//            
            NSString *currentMonth = [NSString stringWithFormat:@"%02lu",row + 1];
            [dateLabel setText:currentMonth];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2: {
            NSRange dateRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                    inUnit:NSCalendarUnitMonth
                                                   forDate:[self.selectedDateComponets date]];
            NSString *currentDay = [NSString stringWithFormat:@"%02lu", (row + 1) % (dateRange.length + 1)];
            [dateLabel setText:currentDay];
            dateLabel.textAlignment = NSTextAlignmentLeft;
            break;
        }
        default:
            break;
    }
    
    return dateLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0: {
            NSDateComponents *indicatorComponents = [self.calendar components:NSCalendarUnitYear
                                                                     fromDate:self.startDate];
            NSInteger year = [indicatorComponents year] + row;
            [self.selectedDateComponets setYear:year];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            break;
        }
        case 1: {
            [self.selectedDateComponets setMonth:row + 1];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
        }
        case 2: {
            [self.selectedDateComponets setDay:row + 1];
            break;
        }
        default:
            break;
    }
    [pickerView reloadAllComponents]; // 注意，这一句不能掉，否则选择后每一栏的数据不会重载，其作用与UITableView中的reloadData相似
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

@end
