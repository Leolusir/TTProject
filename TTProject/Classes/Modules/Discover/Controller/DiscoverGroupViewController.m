//
//  DiscoverGroupViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "DiscoverGroupViewController.h"
#import "DiscoverViewController.h"

@interface DiscoverGroupViewController ()

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) BaseViewController *selectedViewController;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation DiscoverGroupViewController

#pragma mark - Life Cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"发现" titleColor:Color_Gray1 selectedTitleColor:Color_Green1 icon:[UIImage imageNamed:@"icon_tabbar_discover_normal"] selectedIcon:[UIImage imageNamed:@"icon_tabbar_discover_selected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNavigationBar];
    
    [self initSubViewController];
}

#pragma mark - Private Methods

- (void)addNavigationBar
{
    [super addNavigationBar];
    
    NSArray *items = @[@"最新",@"最热"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.frame = CGRectMake(0, 0, 152, 30);
    self.segmentedControl.tintColor = Color_White;
    self.segmentedControl.centerX = self.navigationBar.width / 2;
    self.segmentedControl.bottom = self.navigationBar.height - 8;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged) forControlEvents:UIControlEventValueChanged];
    [self.navigationBar addSubview:self.segmentedControl];
    
    UIImage *addImage = [UIImage imageNamed:@"icon_nav_add"];
    UIButton *addPostButton = [UIButton rightBarButtonWithImage:addImage highlightedImage:addImage target:self action:@selector(addPost) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:addPostButton];
}

- (void)initSubViewController
{
    
    DiscoverViewController *newDiscoverViewController = [[DiscoverViewController alloc] init];
    [self addChildViewController:newDiscoverViewController];
    
    DiscoverViewController *hotDiscoverViewController = [[DiscoverViewController alloc] init];
    [self addChildViewController:hotDiscoverViewController];
    
    self.viewControllers = @[newDiscoverViewController, hotDiscoverViewController];
    
    self.selectIndex = 0;
    self.selectedViewController = self.viewControllers[0];
    
    [self.view insertSubview:self.selectedViewController.view belowSubview:self.navigationBar];
    
}

#pragma mark - Event Response

- (void)segmentedControlChanged
{
    if (self.segmentedControl.selectedSegmentIndex < self.viewControllers.count){
        [self.selectedViewController.view removeFromSuperview];
        
        self.selectIndex = self.segmentedControl.selectedSegmentIndex;
        self.selectedViewController = self.viewControllers[self.selectIndex];
        
        [self.view insertSubview:self.selectedViewController.view belowSubview:self.navigationBar];
    }
}

- (void)addPost
{
    [[TTNavigationService sharedService] openUrl:@"jump://post_publish"];
}

@end
