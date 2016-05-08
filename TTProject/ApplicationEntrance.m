//
//  ApplicationEntrance.m
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "ApplicationEntrance.h"

#import "TTAppLaunchView.h"

#import "DiscoverViewController.h"
#import "TitleListViewController.h"
#import "RecordViewController.h"
#import "MeViewController.h"

#import "SignInUpViewController.h"
#import "TTUserService.h"

#import "GeTuiSdk.h"

#import "UserRequest.h"

@interface ApplicationEntrance () <GeTuiSdkDelegate>

@property (nonatomic, strong) NSDictionary *remoteInfo;
@property (nonatomic, strong) NSString *clientId;

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
    
    // 注册推送
    [self registerAPNs];
    
    //主页面初始化
    [self initViewControllers];
    
    //应用初始化
    [self appInit];
    
    // 个推初始化
    [GeTuiSdk startSdkWithAppId:GETUI_APP_ID appKey:GETUI_APP_KEY appSecret:GETUI_APP_SECRET delegate:self];
    
    [self umengInit];
    
    // 高德
    [self amapInit];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)applicationActive
{
    [self handleRemoteInfo];
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
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    DBG(@"applicationRegisterDeviceToken: %@", token);
    
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

- (void)applicationFailToRegisterDeviceToken:(NSError*)error
{
    
    DBG(@"applicationFailToRegisterDeviceToken: %@", [error localizedDescription]);
    
}

- (void)applicationReceiveNotifaction:(NSDictionary*)userInfo
{
    DBG(@"applicationReceiveNotifaction: %@", userInfo);
    
    self.remoteInfo = userInfo;
}

- (BOOL)applicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return NO;
}

- (BOOL)applicationHandleOpenURL:(NSURL *)url {
    
    return NO;
    
}

- (void)applicationPerformFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    DBG(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    self.remoteInfo = userInfo;
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - Private Methods

- (void)amapInit
{
    [AMapLocationServices sharedServices].apiKey = AMAP_LOCATION_KEY;
    [MAMapServices sharedServices].apiKey = AMAP_LOCATION_KEY;
    [AMapSearchServices sharedServices].apiKey = AMAP_SEARCH_KEY;
}

- (void)umengInit {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
#endif
    
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    
    [MobClick startWithAppkey:UM_APP_KEY reportPolicy:REALTIME channelId:CHANNEL];
    
    [MobClick setEncryptEnabled:YES];
}

- (BOOL)handleRemoteInfo
{
    if (self.remoteInfo && [[self.remoteInfo allKeys] containsObject:@"payload"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_APP_NEW_MESSAGE_RECEIVED object:nil];
        
        self.remoteInfo = nil;
        
        return YES;
        
    } else {
        
        self.remoteInfo = nil;
        
        return NO;
        
    }
    
}

// 初始化数据
- (void)appInit
{
    
    if ( ![TTUserService sharedService].isLogin ) {
        [[TTNavigationService sharedService] openUrl:@"jump://sign_in_up"];
    }
    
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
                              [[DiscoverViewController alloc] init],
                              [[TitleListViewController alloc] init],
                              [[RecordViewController alloc] init],
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

#pragma mark - GeTuiSdkDelegate

//个推SDK已注册，返回clientId
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    DBG(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    
    self.clientId = clientId;
    
    if ( [TTUserService sharedService].isLogin ) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setSafeObject:clientId forKey:@"clientId"];
        [params setSafeObject:[TTUserService sharedService].id forKey:@"userId"];
        [params setSafeObject:@"ios" forKey:@"deviceType"];
        
        [UserRequest registerClientIdWithParams:params success:^(AppInitResultModel *resultModel) {
            
            if ( resultModel ) {
                if ( resultModel.version > APP_VERSION ) {
                    // TODO 提示更新
                }
                
                if ( resultModel.newMsg > 0 ) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_APP_NEW_MESSAGE_RECEIVED object:nil];
                }
            }
            
        } failure:^(StatusModel *status) {
            
        }];
        
    }
    
}

//个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    DBG(@"\n>>>[GeTuiSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    DBG(@"\n>>>[GeTuiSdk ReceivePayload]:%@\n\n", msg);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_APP_NEW_MESSAGE_RECEIVED object:nil];
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    DBG(@"\n>>>[GeTuiSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    DBG(@"\n>>>[GeTuiSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        DBG(@"\n>>>[GeTuiSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    DBG(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}


@end
