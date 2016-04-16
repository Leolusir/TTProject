//
//  TTMDTextField.h
//  TTProject
//
//  Created by Ivan on 16/4/14.
//  Copyright © 2016年 ivan. All rights reserved.
//

@protocol TTMDTextFieldDelegate;

@interface TTMDTextField : UITextField

- (instancetype)initWithFrame:(CGRect)frame
                  normalColor:(UIColor *)normalColor
                   errorColor:(UIColor *)errorColor
                disabledColor:(UIColor *)disabledColor
                    textColor:(UIColor *)textColor
         placeholderTextColor:(UIColor *)placeholderTextColor
                titleFontSize:(CGFloat)titleFontSize
                 textFontSize:(CGFloat)textFontSize;

- (void)showError:(NSString *)errorMsg;

@end

@protocol TTMDTextFieldDelegate <UITextFieldDelegate>

@end