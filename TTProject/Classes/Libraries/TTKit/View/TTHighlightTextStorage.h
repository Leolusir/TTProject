//
//  TTHighlightTextStorage.h
//  TTProject
//
//  Created by Ivan on 16/4/15.
//  Copyright © 2016年 ivan. All rights reserved.
//

@interface TTHighlightTextStorage : NSTextStorage

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, assign) CGFloat fontSize;

- (instancetype)initWithHighlightColor:(UIColor *)color pattern:(NSString *)pattern;

@end
