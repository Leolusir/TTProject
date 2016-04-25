//
//  ApplicationEntrance.m
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "ApplicationEntrance.h"

#import "TTAppLaunchView.h"

#import "DiscoverGroupViewController.h"
#import "TitleGroupViewController.h"
#import "MessageViewController.h"
#import "MeViewController.h"

#import "SignInUpViewController.h"
#import "TTUserService.h"

@interface ApplicationEntrance ()

@end

@implementation ApplicationEntrance

+ (ApplicationEntrance*)shareEntrance
{
    static ApplicationEntrance *entrance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        entrance = [[ApplicationEntrance alloc] init];
    });
    return entrance;
}

- (void)applicationEntrance:(UIWindow *)mainWindow launchOptions:(NSDictionary *)launchOptions
{
    
    self.window = mainWindow;
    
    [self registerAPNs];
    
    //主页面初始化
    [self initViewControllers];
    
    //应用初始化
    [self appInit];
    
    // 高德
    [AMapLocationServices sharedServices].apiKey = @"b53d77dabc08fbee9b3741bbddf88a53";
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationActive
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationEnterBackground
{

}

- (void)handleOpenURL:(NSString *)aUrl
{
    [[TTNavigationService sharedService] openUrl:aUrl];
}

- (void)applicationRegisterDeviceToken:(NSData*)deviceToken
{
    
}

- (void)applicationFailToRegisterDeviceToken:(NSError*)error
{
    
}

- (void)applicationReceiveNotifaction:(NSDictionary*)userInfo
{
    
}

- (BOOL)applicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return NO;
}

- (BOOL)applicationHandleOpenURL:(NSURL *)url {
    
    return NO;
    
}

// 初始化数据
- (void)appInit
{
    
    if ( ![TTUserService sharedService].isLogin ) {
        
        [[TTNavigationService sharedService] openUrl:@"jump://sign_in_up"];
    }
//    [TTAppLaunchView sharedInstance];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_APP_LAUNCH_LOADING object:nil];
    
}

- (void)registerAPNs
{
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

- (void)initViewControllers
{
    self.tabbarController = [[TTTabbarController alloc] initWithViewControllers:
                            @[
                              [[DiscoverGroupViewController alloc] init],
                              [[TitleGroupViewController alloc] init],
                              [[MessageViewController alloc] init],
                              [[MeViewController alloc] init]
                              ]
                            ];
    
    self.tabbarController.tabBarControllerDelegate = self;
    
    TTNavigationController *navigationController = [[TTNavigationController alloc] initWithRootViewController:self.tabbarController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    self.currentNavController = navigationController;
    
}

- (TTNavigationController *)currentNavigationController
{
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (self.currentNavController) {
        return self.currentNavController;
    }
    
    TTNavigationController *nav;
    if ([rootController isKindOfClass:[TTNavigationController class]]) {
        nav = (TTNavigationController *)rootController;
        self.currentNavController = nav;
    } else if ([rootController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarController = (UITabBarController *)rootController;
        if ([tabbarController.selectedViewController isKindOfClass:[TTNavigationController class]]) {
            nav = (TTNavigationController *)tabbarController.selectedViewController;
            self.currentNavController = nav;
        }
    }
    return nav;
}

#pragma mark - TTTabBarDelegate
- (BOOL)tabBarController:(TTTabbarController *)tabBarController shouldSelectViewController:(BaseViewController *)viewController atIndex:(NSInteger)index
{
    return YES;
}

- (void)tabBarController:(TTTabbarController *)tabBarController didSelectViewController:(BaseViewController *)viewController atIndex:(NSInteger)index
{

}


@end
