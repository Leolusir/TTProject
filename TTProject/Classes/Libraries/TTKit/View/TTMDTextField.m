//
//  TTMDTextField.m
//  TTProject
//
//  Created by Ivan on 16/4/14.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTMDTextField.h"

@interface TTMDTextField ()

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *errorColor;
@property (nonatomic, strong) UIColor *disabledColor;
@property (nonatomic, strong) UIColor *placeholderTextColor;
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, assign) CGFloat textFontSize;

@property (nonatomic, strong) NSString *placeholderText;

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TTMDTextField

#pragma mark - Override Methods

- (instancetype)initWithFrame:(CGRect)frame
                  normalColor:(UIColor *)normalColor
                   errorColor:(UIColor *)errorColor
                disabledColor:(UIColor *)disabledColor
                    textColor:(UIColor *)textColor
         placeholderTextColor:(UIColor *)placeholderTextColor
                titleFontSize:(CGFloat)titleFontSize
                 textFontSize:(CGFloat)textFontSize;
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.normalColor = normalColor;
        self.errorColor = errorColor;
        self.disabledColor = disabledColor;
        self.placeholderTextColor = placeholderTextColor;
        self.textColor = textColor;
        self.titleFontSize = titleFontSize;
        self.textFontSize = textFontSize;
        
        [self prepareView];
        
    }
    
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if ( placeholder ) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : self.placeholderTextColor}];
    } else {
        self.attributedPlaceholder = nil;
    }
}

#pragma mark - Custom Methods

- (void)showError:(NSString *)errorMsg
{
    if( self.text.length > 0 ){
        self.titleLabel.textColor = self.errorColor;
        if ( errorMsg && errorMsg.length > 0 ) {
            self.titleLabel.text = errorMsg;
        }
    }
    
    self.lineLayer.frame = CGRectMake(0, self.bounds.size.height + 2, self.bounds.size.width, LINE_WIDTH * 2);
    self.lineLayer.backgroundColor = self.errorColor.CGColor;
}

#pragma mark - Getters And Setters

- (void)setEnabled:(BOOL)enabled
{
    super.enabled = enabled;
    
    self.lineLayer.frame = CGRectMake(0, self.bounds.size.height + 2, self.bounds.size.width, LINE_WIDTH);
    self.lineLayer.backgroundColor = enabled ? self.normalColor.CGColor : self.disabledColor.CGColor;
    self.titleLabel.textColor = enabled ? self.normalColor : self.disabledColor;
    
}

#pragma mark - Private Methods

- (void)prepareView
{
 
    self.clipsToBounds = NO;
    self.backgroundColor = Color_White;
    self.font = FONT(self.textFontSize);
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self prepareTitleLabel];
    [self prepareLineLayer];
    
    [self addTarget:self action:@selector(textFieldDidBegin) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(textFieldValueChanged) forControlEvents:UIControlEventValueChanged];

}

- (void)textFieldDidBegin
{
    [self showTitleLabel];
    
    if ( [self.titleLabel.text isEqualToString:self.placeholderText] ) {
        self.titleLabel.textColor = self.normalColor;
    }
    self.lineLayer.frame = CGRectMake(0, self.bounds.size.height + 2, self.bounds.size.width, LINE_WIDTH * 2);
    
    if ( [self.titleLabel.text isEqualToString:self.placeholderText] ) {
        self.lineLayer.backgroundColor = self.normalColor.CGColor;
    }
}

- (void)textFieldDidChange
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)textFieldDidEnd
{
    if ( self.text.length > 0 ) {
        [self showTitleLabel];
        
        if ( [self.titleLabel.text isEqualToString:self.placeholderText] ) {
            self.titleLabel.textColor = self.normalColor;
        }
        
    } else {
        [self hideTitleLabel];
        self.titleLabel.textColor = self.placeholderTextColor;
    }
    
    self.lineLayer.frame = CGRectMake(0, self.bounds.size.height + 2, self.bounds.size.width, LINE_WIDTH);
    
    if ( [self.titleLabel.text isEqualToString:self.placeholderText] ) {
        self.lineLayer.backgroundColor = self.normalColor.CGColor;
    }
    
}

- (void)textFieldValueChanged
{
    self.titleLabel.textColor = self.normalColor;
    self.titleLabel.text = self.placeholderText;
    self.lineLayer.frame = CGRectMake(0, self.bounds.size.height + 2, self.bounds.size.width, LINE_WIDTH * 2);
    self.lineLayer.backgroundColor = self.normalColor.CGColor;
}

- (void)prepareTitleLabel
{
    self.titleLabel = [[UILabel alloc] init];
    
    self.titleLabel.hidden = YES;
    self.titleLabel.font = BOLD_FONT(self.titleFontSize);
    [self addSubview:self.titleLabel];
    
    self.titleLabel.textColor = self.normalColor;
    self.tintColor = self.normalColor;
    
    if ( self.text.length > 0 ) {
        [self showTitleLabel];
    } else {
        self.titleLabel.alpha = 0;
    }
    
}

- (void)showTitleLabel
{
    if ( self.titleLabel.hidden ) {
        
        if ( self.placeholder ) {
            self.titleLabel.text = self.placeholder;
            self.placeholderText = self.placeholder;
            self.placeholder = nil;
        }
        
        CGFloat height = ceil(self.titleLabel.font.lineHeight);
        self.titleLabel.frame = self.bounds;
        self.titleLabel.font = self.font;
        self.titleLabel.hidden = NO;
        
        weakify(self);
        [UIView animateWithDuration:0.15f animations:^{
            
            strongify(self);
            self.titleLabel.alpha = 1;
            self.titleLabel.transform = CGAffineTransformScale(self.titleLabel.transform, self.titleFontSize / self.textFontSize, self.titleFontSize / self.textFontSize);
            self.titleLabel.frame = CGRectMake(0, - ( 2 + height ), self.bounds.size.width, height);
            
        }];
        
    }
}

- (void)hideTitleLabel
{
    weakify(self);
    [UIView animateWithDuration:0.15f animations:^{
        
        strongify(self);
        self.titleLabel.transform = CGAffineTransformIdentity;
        self.titleLabel.frame = self.bounds;
        
    } completion:^(BOOL finished) {
        
        strongify(self);
        self.placeholder = self.placeholderText;
        self.titleLabel.hidden = YES;
        
    }];
}

- (void)prepareLineLayer
{
    self.lineLayer = [[CAShapeLayer alloc] init];
    [self layoutLineLayer];
    [self.layer addSublayer:self.lineLayer];
}

- (void)layoutLineLayer
{
    self.lineLayer.frame = CGRectMake(0, self.bounds.size.height + 2, self.bounds.size.width, LINE_WIDTH);
    self.lineLayer.backgroundColor = self.normalColor.CGColor;
}

@end
