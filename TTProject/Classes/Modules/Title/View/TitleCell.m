//
//  TopicCell.m
//  TTProject
//
//  Created by Ivan on 16/4/22.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TitleCell.h"
#import "TitleModel.h"

#define PADDING 10

@interface TitleCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation TitleCell

- (void)drawCell{
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.countLabel];
    
}

- (void)reloadData{
    
    if ( self.cellData ) {
        
        TitleModel *topic = (TitleModel *)self.cellData;
        
        self.titleLabel.text = [NSString stringWithFormat:@"# %@ #", topic.id];
        self.countLabel.text = [NSString stringWithFormat:@"%ld条内容", (long)topic.ref];
        
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    if (cellData) {
        return 50;
    }
    return 0;
}

#pragma mark - Getters And Setters

- (UILabel *)titleLabel
{
    if ( !_titleLabel ) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, 8, SCREEN_WIDTH - PADDING * 2, 0)];
        _titleLabel.textColor = Color_Gray2;
        _titleLabel.font = FONT(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"# 话题 #";
        [_titleLabel sizeToFit];
        _titleLabel.width = SCREEN_WIDTH - PADDING * 2;
    }
    
    return _titleLabel;
}

- (UILabel *)countLabel
{
    if ( !_countLabel ) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, self.titleLabel.bottom + 2, SCREEN_WIDTH - PADDING * 2, 0)];
        _countLabel.textColor = Color_Gray1;
        _countLabel.font = FONT(10);
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.text = @"0条内容";
        [_countLabel sizeToFit];
        _countLabel.width = SCREEN_WIDTH - PADDING * 2;
    }
    
    return _countLabel;
}

@end
