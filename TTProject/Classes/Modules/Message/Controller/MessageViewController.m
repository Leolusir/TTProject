//
//  MessageViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/12.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "MessageViewController.h"

@implementation MessageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"消息" titleColor:Color_Gray146 selectedTitleColor:Color_Red2 icon:[UIImage imageNamed:@"icon_tabbar_index"] selectedIcon:[UIImage imageNamed:@"icon_tabbar_index_selected"]];
    }
    return self;
}

@end
