//
//  TTHighlightTextView.m
//  TTProject
//
//  Created by Ivan on 16/4/15.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTHighlightTextView.h"
#import "TTHighlightTextStorage.h"

@interface TTHighlightTextView ()

@end

@implementation TTHighlightTextView

- (instancetype)initWithFrame:(CGRect)frame highlightColor:(UIColor *)color pattern:(NSString *)pattern
{
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    TTHighlightTextStorage *textStorage = [[TTHighlightTextStorage alloc] initWithHighlightColor:color pattern:pattern];
    [textStorage addLayoutManager:layoutManager];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)];
    [layoutManager addTextContainer:textContainer];
    
    self = [super initWithFrame:frame textContainer:textContainer];
    
//    if (self) {
//        
//    }
    
    return self;
}

#pragma mark - Override Methods

- (void)setTextColor:(UIColor *)textColor
{
    super.textColor = textColor;
    ((TTHighlightTextStorage *)self.textStorage).normalColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    super.font = font;
    ((TTHighlightTextStorage *)self.textStorage).fontSize = font.pointSize;
}

@end
