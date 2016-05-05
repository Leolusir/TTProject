//
//  AppDelegate.m
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    [[ApplicationEntrance shareEntrance] applicationEntrance:self.window launchOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[ApplicationEntrance shareEntrance] applicationEnterBackground];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[ApplicationEntrance shareEntrance] applicationActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [[ApplicationEntrance shareEntrance] applicationRegisterDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    [[ApplicationEntrance shareEntrance] applicationFailToRegisterDeviceToken:error];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [[ApplicationEntrance shareEntrance] applicationReceiveNotifaction:userinfo];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return [[ApplicationEntrance shareEntrance] applicationOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [[ApplicationEntrance shareEntrance] applicationHandleOpenURL:url];
    
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [[ApplicationEntrance shareEntrance] applicationPerformFetchWithCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[ApplicationEntrance shareEntrance] applicationDidReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

@end
