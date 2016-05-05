//
//  TTMapViewController.m
//  TTProject
//
//  Created by Ivan on 16/5/5.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTMapViewController.h"

@interface TTMapViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation TTMapViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    
    [self addNavigationBar];
    
    self.title = @"瞭望";
    
    [self render];
    
}

#pragma mark - Private Methods

- (void) render {
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
}

@end
