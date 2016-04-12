//
//  TTAppLaunchView.h
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTAppLaunchView.h"

@interface TTAppLaunchView ()

@property (nonatomic, strong) UIImageView *launchImageView;
@property (nonatomic, assign) BOOL startImageRemove;

@end

@implementation TTAppLaunchView

+ (TTAppLaunchView *)sharedInstance
{
    static dispatch_once_t onceToken;
    static TTAppLaunchView *launchView = nil;
    dispatch_once(&onceToken, ^{
        launchView = [[TTAppLaunchView alloc] init];
    });
    
    return launchView;
}

- (instancetype)init
{
    self = [super init];

    self.bounds = [[UIScreen mainScreen] bounds];
    self.left = 0.f;
    self.top = 0.f;
    
    if (self) {
        
        [self loadContent];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLaunchView) name:kNOTIFY_APP_LAUNCH_LOADING object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLaunchView) name:kNOTIFY_APP_LAUNCH_REMOVE object:nil];
        
    }
    
    return self;
}

#pragma mark - load methods
- (void)loadContent
{
    if (!self.launchImageView) {
        
        self.startImageRemove = NO;
        
        UIImage *image;
        
        if (IS_IPHONE4) {
            image = [UIImage imageNamed:@"app_loading_fg4"];
        } else if (IS_IPHONE5) {
            image = [UIImage imageNamed:@"app_loading_fg5"];
        } else if (IS_IPHONE6) {
            image = [UIImage imageNamed:@"app_loading_fg6"];
        } else if (IS_IPHONE6Plus) {
            image = [UIImage imageNamed:@"app_loading_fg6p"];
        }
        
        self.launchImageView = [[UIImageView alloc] initWithImage:image];
        self.launchImageView.frame = CGRectMake(0.f, 0.f, self.width, self.height);
        self.backgroundColor = Color_White;
        self.launchImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:self.launchImageView];
    }
}

#pragma mark - notification methods

- (void)showLaunchView
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:self];
}

- (void)removeLaunchView
{
    
    
    if (!self.startImageRemove) {
        
        self.startImageRemove = YES;
        
        [NSThread sleepForTimeInterval:0.8f];
        if (self.superview) {
            [UIView animateWithDuration:0.4
                             animations:^{
                                 self.alpha = 0.f;
                             } completion:^(BOOL finished) {
                                 [self removeFromSuperview];
                                 
                             }];
        }
    }
    
}

@end
