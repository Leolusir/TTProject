//
//  AppModuleEntrance.m
//  TTProject
//
//  Created by Ivan on 16/1/31.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "AppModuleEntrance.h"

#import "TTNavigationService.h"
#import "TTNavigationController.h"

#import "SignInUpViewController.h"

@implementation AppModuleEntrance

+ (id)sharedEntrance
{
    static dispatch_once_t onceToken;
    static AppModuleEntrance *moduleEntrance = nil;
    dispatch_once(&onceToken, ^{
        moduleEntrance = [[AppModuleEntrance alloc] init];
    });
    return moduleEntrance;
}

+ (void)load
{
    // 登录注册
    [[TTNavigationService sharedService] registerModule:self withScheme:APP_SCHEME host:@"sign_in_up"];
    
    // 发现首页
    [[TTNavigationService sharedService] registerModule:self withScheme:APP_SCHEME host:@"discover"];
    
}

- (void)handleOpenUrl:(NSString *)urlString userInfo:(NSDictionary *)userInfo from:(id)from complete:(void (^)())complete
{
    TTNavigationController *navigationController = [[ApplicationEntrance shareEntrance] currentNavigationController];
    
    NSString *strUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSMutableDictionary *urlParams = [[url parameters] mutableCopy];
    
    if ([url.scheme isEqualToString:APP_SCHEME]) {
        
        if([url.host isEqualToString:@"sign_in_up"]) {
            
            if( [navigationController.childViewControllers count] > 1 ){
                [navigationController popToRootViewControllerAnimated:NO onCompletion:^{
                    SignInUpViewController *vc = [[SignInUpViewController alloc] init];
                    [navigationController pushViewController:vc animated:NO];
                }];
            } else {
                SignInUpViewController *vc = [[SignInUpViewController alloc] init];
                [navigationController pushViewController:vc animated:NO];
            }
            
        } else if([url.host isEqualToString:@"discover"]) {
            
            if( [navigationController.childViewControllers count] > 1 ){
                [navigationController popToRootViewControllerAnimated:NO onCompletion:^{
                    [[ApplicationEntrance shareEntrance].tabbarController selectAtIndex:0];
                }];
            } else {
                [[ApplicationEntrance shareEntrance].tabbarController selectAtIndex:0];
            }
            
        }
        
    }
    
}

@end
