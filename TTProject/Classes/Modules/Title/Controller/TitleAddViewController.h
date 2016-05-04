//
//  TitleAddViewController.h
//  TTProject
//
//  Created by Ivan on 16/5/4.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^TitleAddBlock)(NSString *title);

@interface TitleAddViewController : BaseViewController

@property (nonatomic, strong) TitleAddBlock callback;

@end
