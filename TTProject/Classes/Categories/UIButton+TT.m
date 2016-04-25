//
//  UIButton+TT.m
//  TTProject
//
//  Created by Ivan on 16/1/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "UIButton+TT.h"

@implementation UIButton (TT)

+ (UIButton *)backButtonWithTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	return [self leftBarButtonWithImage:[UIImage imageNamed:@"icon_back"] highlightedImage:[UIImage imageNamed:@"icon_back"] target:target action:action forControlEvents:UIControlEventTouchUpInside];
}

+ (UIButton *)leftBarButtonWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0.0f, 0.0f, 44, 44);
    barButton.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
	[barButton setImage:image forState:UIControlStateNormal];
    [barButton setImage:highlightedImage forState:UIControlStateHighlighted];
	[barButton addTarget:target action:action forControlEvents:controlEvents];
    [barButton setExclusiveTouch:YES];
	return barButton;
}

+ (UIButton *)rightBarButtonWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0.0f, 0.0f, 44, 44);
    barButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
	[barButton setImage:image forState:UIControlStateNormal];
    [barButton setImage:highlightedImage forState:UIControlStateHighlighted];
	[barButton addTarget:target action:action forControlEvents:controlEvents];
    [barButton setExclusiveTouch:YES];
	return barButton;
}

+ (UIButton *)buttonWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    
    return [self buttonWithTitle:nil image:image highlightedImage:highlightedImage backgroundImage:nil highlightedBackgroundImage:nil target:target action:action forControlEvents:controlEvents];
    
}

+ (UIButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage backgroundImage:(UIImage *)backgroundImage highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = CGSizeZero;
    if (backgroundImage) {
        size = backgroundImage.size;
    } else if (image) {
        size = image.size;
    }
    
    button.frame = CGRectMake(0.0f, 0.0f, size.width < 44.0f ? 44.0f : size.width, size.height < 44.0f ? 44.0f : size.height);
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    
	[button addTarget:target action:action forControlEvents:controlEvents];
    
    [button setExclusiveTouch:YES];
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font frame:(CGRect)frame target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame  = frame;
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:Color_Green1 forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:controlEvents];
    [button setExclusiveTouch:YES];
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color highlightedColor:(UIColor *)highlightedColor target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    
    if (button.width < 44) {
        button.width = 44;
    }
    
    if (button.height < 44) {
        button.height = 44;
    }
    
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:controlEvents];
    [button setExclusiveTouch:YES];
    
    return button;
}

+ (UIButton *)buttonWithImage:(UIImage*)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    
    [button addTarget:target action:action forControlEvents:controlEvents];
    [button setExclusiveTouch:YES];
    
    return button;
    
}

@end
