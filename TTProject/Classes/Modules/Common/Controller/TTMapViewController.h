//
//  TTMapViewController.h
//  TTProject
//
//  Created by Ivan on 16/5/5.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseViewController.h"

@protocol TTMapViewDelegate;

@interface TTMapViewController : BaseViewController

@property (nonatomic, weak) id<TTMapViewDelegate> delegate;

@end

@protocol TTMapViewDelegate <NSObject>

@optional

@end