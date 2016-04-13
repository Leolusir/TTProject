//
//  TTEmptyTipsView.m
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTEmptyTipsView.h"

@implementation TTEmptyTipsView

- (id)initWithFrame:(CGRect)frame tips:(NSString *)tips
{
    self = [super initWithFrame:frame];
    if (self) {
        self.width = SCREEN_WIDTH;
        // Initialization code
        if (!tips || tips.length == 0) {
            tips = @"还没有内容";
        }
        
        self.userInteractionEnabled = NO;
        
        UILabel *_tipsLabel = [UILabel labelWithText:tips color:Color_Gray3 align:NSTextAlignmentCenter font:FONT(14) background:[UIColor clearColor] frame:CGRectMake(0, 100.f, self.width, 15.f)];
        [self addSubview:_tipsLabel];
    }
    
    return self;
}




@end
