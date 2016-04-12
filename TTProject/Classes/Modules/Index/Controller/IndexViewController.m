//
//  IndexViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/9.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "IndexViewController.h"

@implementation IndexViewController

#pragma mark - Life Cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"首页" titleColor:Color_Gray146 selectedTitleColor:Color_Red2 icon:[UIImage imageNamed:@"icon_tabbar_index"] selectedIcon:[UIImage imageNamed:@"icon_tabbar_index_selected"]];
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"首页";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_APP_LAUNCH_REMOVE object:nil];
}

@end
