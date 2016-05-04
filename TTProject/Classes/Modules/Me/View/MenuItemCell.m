//
//  MenuItemCell.m
//  TTProject
//
//  Created by Ivan on 16/4/29.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "MenuItemCell.h"

@interface MenuItemCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation MenuItemCell

- (void)drawCell{
    
    self.backgroundColor = Color_White;
    [self addSubview:self.lineView];
    [self addSubview:self.moreImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.valueLabel];
    
}

- (void)reloadData{
    
    if ( self.cellData ) {
        
        NSDictionary *data = (NSDictionary *)self.cellData;
        
        if ( [data objectForKey:@"title"] ) {
            self.titleLabel.hidden = NO;
            self.titleLabel.text = data[@"title"];
        } else {
            self.titleLabel.hidden = YES;
        }
        
        if ( [data objectForKey:@"value"] ) {
            self.valueLabel.hidden = NO;
            self.valueLabel.text = data[@"value"];
        } else {
            self.valueLabel.hidden = YES;
        }
        
        if ( [data[@"line"] boolValue] ) {
            self.lineView.hidden = NO;
        } else {
            self.lineView.hidden = YES;
        }
        
        if ( [data[@"arrow"] boolValue] ) {
            self.moreImageView.hidden = NO;
            self.valueLabel.right = self.moreImageView.left - 10;
        } else {
            self.moreImageView.hidden = YES;
            self.valueLabel.right = SCREEN_WIDTH - 20;
        }
        
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    return 60;
}

#pragma mark - Getters And Setters

- (UIImageView *)moreImageView
{
    if ( !_moreImageView ) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_more"]];
        _moreImageView.centerY = 30;
        _moreImageView.right = SCREEN_WIDTH - 20;
    }
    
    return _moreImageView;
}

- (UIView *)lineView
{
    if ( !_lineView ) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, LINE_WIDTH)];
        _lineView.backgroundColor = Color_Gray1;
        _lineView.bottom = 60;
    }
    
    return _lineView;
}

- (UILabel *)titleLabel
{
    if ( !_titleLabel ) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 60, 60)];
        _titleLabel.textColor = Color_Gray2;
        _titleLabel.font = FONT(16);
    }
    
    return _titleLabel;
}

- (UILabel *)valueLabel
{
    if ( !_valueLabel ) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 60, 60)];
        _valueLabel.textColor = Color_Gray3;
        _valueLabel.font = FONT(14);
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _valueLabel;
}

@end
