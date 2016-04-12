//
// UIScrollView+SVInfiniteScrolling.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>

@class BaseRefreshView;

@class SVInfiniteScrollingView;

@interface UIScrollView (SVInfiniteScrolling)

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)triggerInfiniteScrolling;

@property (nonatomic, strong, readonly) SVInfiniteScrollingView *infiniteScrollingView;
@property (nonatomic, assign) BOOL showsInfiniteScrolling;

@end

typedef NS_ENUM(NSUInteger, SVInfiniteScrollingState){
	SVInfiniteScrollingStateStopped = 0,
    SVInfiniteScrollingStateTriggered,
    SVInfiniteScrollingStateLoading,
    SVInfiniteScrollingStateAll = 10
};

@interface SVInfiniteScrollingView : UIView

@property (nonatomic, readonly) SVInfiniteScrollingState state;
@property (nonatomic, readwrite) BOOL enabled;

@property (nonatomic, strong) BaseRefreshView *refreshView;
@property (nonatomic, assign) BOOL hasRefreshView;
- (void)addRefreshView:(BaseRefreshView *)refreshView;

- (void)startAnimating;
- (void)stopAnimating;

@end
