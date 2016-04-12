//
//  CommonMacro.h
//  TTProject
//
//  Created by Ivan on 16/1/23.
//  Copyright © 2016年 ivan. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h

// 加载类型
typedef NS_ENUM(NSInteger, LoadingType)
{
    LoadingTypeInit = 0,    // 初始
    LoadingTypeRefresh,     // 刷新
    LoadingTypeLoadMore,    // 加载更多
};

// 消息类型
typedef NS_ENUM(NSInteger, MessageType)
{
    /**
     *  文本类型消息
     */
    MessageTypeText          = 0,
    /**
     *  图片类型消息
     */
    MessageTypeImage         = 1,
    /**
     *  声音类型消息
     */
    MessageTypeAudio         = 2,
    /**
     *  视频类型消息
     */
    MessageTypeVideo         = 3,
    /**
     *  位置类型消息
     */
    MessageTypeLocation      = 4,
    /**
     *  通知类型消息
     */
    MessageTypeNotification  = 5,
    /**
     *  文件类型消息
     */
    MessageTypeFile          = 6,
    /**
     *  提醒类型消息
     */
    MessageTypeTip           = 10,
    /**
     *  时间类型消息
     */
    MessageTypeTime          = 1000,
    /**
     *  未知类型消息
     */
    MessageTypeUnknow        = 10000
    
};

#endif /* CommonMacro_h */
