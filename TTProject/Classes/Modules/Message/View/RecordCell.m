//
//  RecordCell.m
//  TTProject
//
//  Created by Ivan on 16/4/27.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "RecordCell.h"
#import "RecordModel.h"

@interface RecordCell ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *unreadMarkView;

@end

@implementation RecordCell

- (void)drawCell{
    
    self.backgroundColor = Color_White;
    [self addSubview:self.avatarImageView];
    [self addSubview:self.infoLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.unreadMarkView];
    
    
}

- (void)reloadData{
    
    if ( self.cellData ) {
        
        RecordModel *record = (RecordModel *)self.cellData;
        
        [self.avatarImageView setOnlineImage:record.avatar];
        self.infoLabel.text = [NSString stringWithFormat:@"%@    %@岁", [record.gender isEqualToString:@"m"] ? @"男" : @"女", record.age];
        self.contentLabel.text = record.content;
        self.timeLabel.text = record.createTime;
        
        self.unreadMarkView.hidden = record.status ? NO : YES;
        
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    if (cellData) {
        return 80;
    }
    return 0;
}

#pragma mark - Getters And Setters

- (UIImageView *)avatarImageView
{
    if ( !_avatarImageView ) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
        _avatarImageView.layer.cornerRadius = 20;
    }
    
    return _avatarImageView;
}

- (UILabel *)infoLabel
{
    if ( !_infoLabel ) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, 0, 0)];
        _infoLabel.textColor = Color_Gray3;
        _infoLabel.font = FONT(12);
        _infoLabel.text = @"男    0岁";
        [_infoLabel sizeToFit];
        _infoLabel.width = SCREEN_WIDTH - 180;
    }
    
    return _infoLabel;
}

- (UILabel *)timeLabel
{
    if ( !_timeLabel ) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 0, 0)];
        _timeLabel.textColor = Color_Gray3;
        _timeLabel.font = FONT(10);
        _timeLabel.text = @"刚刚";
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [_timeLabel sizeToFit];
        _timeLabel.width = 80;
        _timeLabel.right = SCREEN_WIDTH - 20;
    }
    
    return _timeLabel;
}

- (UILabel *)contentLabel
{
    if ( !_contentLabel ) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 39, 0, 0)];
        _contentLabel.textColor = Color_Gray2;
        _contentLabel.font = FONT(14);
        _contentLabel.text = @"消息";
        _contentLabel.numberOfLines = 1;
        [_contentLabel sizeToFit];
        _contentLabel.width = SCREEN_WIDTH - 100;
    }
    
    return _contentLabel;
}

- (UIView *)unreadMarkView
{
    if ( !_unreadMarkView ) {
        _unreadMarkView = [[UIView alloc] initWithFrame:CGRectMake(7, 37, 6, 6)];
        _unreadMarkView.backgroundColor = Color_Green1;
        _unreadMarkView.layer.cornerRadius = 3;
    }
    return _unreadMarkView;
}

@end
