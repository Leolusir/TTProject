//
//  TopicGroupViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TitleGroupViewController.h"
#import "TitleListViewController.h"

@interface TitleGroupViewController ()

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) BaseViewController *selectedViewController;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation TitleGroupViewController

#pragma mark - Life Cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"话题" titleColor:Color_Gray1 selectedTitleColor:Color_Green1 icon:[UIImage imageNamed:@"icon_tabbar_topic_normal"] selectedIcon:[UIImage imageNamed:@"icon_tabbar_topic_selected"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.needBlurEffect = NO;
    
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
    
    UIImage *searchImage = [UIImage imageNamed:@"icon_nav_search"];
    UIButton *searchButton = [UIButton leftBarButtonWithImage:searchImage highlightedImage:searchImage target:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setLeftBarButton:searchButton];
    
    UIImage *addImage = [UIImage imageNamed:@"icon_nav_add"];
    UIButton *addTopicButton = [UIButton rightBarButtonWithImage:addImage highlightedImage:addImage target:self action:@selector(addTopic) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:addTopicButton];

}

#pragma mark - Private Methods

- (void)initSubViewController
{
    
    TitleListViewController *newTopicListViewController = [[TitleListViewController alloc] init];
    newTopicListViewController.sort = 0;
    [self addChildViewController:newTopicListViewController];
    
    TitleListViewController *hotTopicListViewController = [[TitleListViewController alloc] init];
    hotTopicListViewController.sort = 1;
    [self addChildViewController:hotTopicListViewController];
    
    self.viewControllers = @[newTopicListViewController, hotTopicListViewController];
    
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

- (void)addTopic
{
    DBG(@"addTopic");
}

- (void)doSearch
{
    DBG(@"doSearch");
}

@end
