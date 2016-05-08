//
//  TitleAddViewController.m
//  TTProject
//
//  Created by Ivan on 16/5/4.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TitleAddViewController.h"

@interface TitleAddViewController ()

@property (nonatomic, strong) UIView *titleAddBgView;
@property (nonatomic, strong) UITextField *titleAddTextField;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation TitleAddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"插入话题";
    
    [self addNavigationBar];
    
    [self addTitleAddView];
    
}

#pragma mark - Override Methods

- (void)addNavigationBar
{
    [super addNavigationBar];
    
    UIImage *cancelImage = [UIImage imageNamed:@"icon_nav_cancel"];
    UIButton *addTitleCancelButton = [UIButton leftBarButtonWithImage:cancelImage highlightedImage:cancelImage target:self action:@selector(handleAddTitleCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setLeftBarButton:addTitleCancelButton];
    
    UIImage *okImage = [UIImage imageNamed:@"icon_nav_ok"];
    UIButton *addTitleOKButton = [UIButton rightBarButtonWithImage:okImage highlightedImage:okImage target:self action:@selector(handleAddTitleOKButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:addTitleOKButton];
    
}

#pragma mark - Private Methods

- (void)addTitleAddView
{
    self.titleAddBgView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, 50)];
    self.titleAddBgView.backgroundColor = Color_White;
    [self.view addSubview:self.titleAddBgView];
    
    self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pub_title"]];
    self.titleImageView.left = 10;
    self.titleImageView.centerY = self.titleAddBgView.height / 2;
    [self.titleAddBgView addSubview:self.titleImageView];
    
    self.titleAddTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.titleImageView.right + 10, 0, SCREEN_WIDTH - 20 - self.titleImageView.right, 32)];
    self.titleAddTextField.centerY = self.titleAddBgView.height / 2;
    self.titleAddTextField.placeholder = @"输入话题名称";
    self.titleAddTextField.font = FONT(14);
    self.titleAddTextField.textColor = Color_Gray2;
    self.titleAddTextField.tintColor = Color_Green1;
    [self.titleAddBgView addSubview:self.titleAddTextField];

}

#pragma mark - Event Response

- (void)handleAddTitleOKButton
{
    DBG(@"handleAddTitleOKButton");
    
    if ( self.titleAddTextField.text.length == 0 ) {
        [self showNotice:@"请输入话题"];
        return;
    }
    
    weakify(self);
    [[[ApplicationEntrance shareEntrance] currentNavigationController] popViewControllerAnimated:NO onCompletion:^{
        strongify(self);
        self.callback(self.titleAddTextField.text);
    }];
}

- (void)handleAddTitleCancelButton
{
    DBG(@"handleAddTitleCancelButton");
    
    [[[ApplicationEntrance shareEntrance] currentNavigationController] popViewControllerAnimated:YES];
}


@end
