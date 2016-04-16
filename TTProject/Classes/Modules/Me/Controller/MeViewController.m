//
//  MeViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "MeViewController.h"

@implementation MeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"我的" titleColor:Color_Gray1 selectedTitleColor:Color_Green1 icon:[UIImage imageNamed:@"icon_tabbar_me_normal"] selectedIcon:[UIImage imageNamed:@"icon_tabbar_me_selected"]];
    }
    return self;
}

@end
