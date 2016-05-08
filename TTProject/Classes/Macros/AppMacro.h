//
//  AppMarco.h
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#ifndef AppMarco_h
#define AppMarco_h

// 当前版本号
#define APP_VERSION                 1000
#define APP_VERSION_SHOW            @"1.0.0.0"

// 应用类型
#define APP_TYPE                    @"iphone"

// 应用名称
#define APP_NAME                    @"seek"

// 应用ID
#define APPLEID                     @"1111117434"


//苹果相关的信息

#define APPSTORE_URL                [NSString stringWithFormat : @"https://itunes.apple.com/cn/app/id%@?ls=1&mt=8", APPLEID]
#define URL_UPDATE                  [NSString stringWithFormat : @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", APPLEID]
#define URL_REVIEW                  [NSString stringWithFormat : @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", APPLEID]

#define UA                          @"seek4iPhone"

#define CHANNEL                     @"AppStore"

#define SOURCE                      [NSString stringWithFormat : @"%@%@", CHANNEL, APP_VERSION]

#endif /* AppMarco_h */
