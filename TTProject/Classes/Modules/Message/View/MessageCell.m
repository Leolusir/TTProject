//
//  MessageCell.m
//  TTProject
//
//  Created by Ivan on 16/4/27.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"

@interface MessageCell ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation MessageCell

- (void)drawCell{
    
    self.backgroundColor = Color_White;
    [self addSubview:self.avatarImageView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.infoLabel];
    
}

- (void)reloadData{
    
    if ( self.cellData ) {
        
        MessageModel *message = (MessageModel *)self.cellData;
        
        
        
        self.contentLabel.text = message.content;
        [self.contentLabel sizeToFit];
        self.contentLabel.width = SCREEN_WIDTH - 100;
        
        self.timeLabel.text = message.createTime;
        [self.timeLabel sizeToFit];
        self.timeLabel.top = self.contentLabel.bottom + 10;
        
        if ( [message.userId isEqualToString:[TTUserService sharedService].id] ) {
            
            UIImage *avatarImage = [UIImage imageNamed:[@"m" isEqualToString:[TTUserService sharedService].gender] ? @"seek_boy_s" : @"seek_girl_s"];
            
            self.avatarImageView.image = avatarImage;
            
            self.infoLabel.text = @"我";
            self.infoLabel.textColor = Color_Green1;
            
        } else {
            [self.avatarImageView setOnlineImage:message.avatar];
            
            self.infoLabel.text = [NSString stringWithFormat:@"%@    %@岁", [message.gender isEqualToString:@"m"] ? @"男" : @"女", message.age];
            self.infoLabel.textColor = Color_Gray3;
        }
        
        
        [self.infoLabel sizeToFit];
        self.infoLabel.top = self.timeLabel.top;
        self.infoLabel.left = self.timeLabel.right + 15;
        
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    if (cellData) {
        
        MessageModel *message = (MessageModel *)cellData;
        CGFloat minHeight = 70;
        
        CGFloat height = 0;
        
        CGSize textSize = [message.content sizeWithUIFont:FONT(12) forWidth:SCREEN_WIDTH - 100];
        
        height = ceil(textSize.height) + 15 + 10 + 15 + 10;
        
        if ( height < minHeight ) {
            height = minHeight;
        }
        
        return height;
    }
    return 0;
}

#pragma mark - Getters And Setters

- (UIImageView *)avatarImageView
{
    if ( !_avatarImageView ) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 40, 40)];
        _avatarImageView.layer.cornerRadius = 20;
    }
    
    return _avatarImageView;
}

- (UILabel *)infoLabel
{
    if ( !_infoLabel ) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _infoLabel.font = FONT(10);
    }
    
    return _infoLabel;
}

- (UILabel *)timeLabel
{
    if ( !_timeLabel ) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 0, 0)];
        _timeLabel.textColor = Color_Gray3;
        _timeLabel.font = FONT(10);
        _timeLabel.text = @"刚刚";
        [_timeLabel sizeToFit];
    }
    
    return _timeLabel;
}

- (UILabel *)contentLabel
{
    if ( !_contentLabel ) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, SCREEN_WIDTH - 100, 0)];
        _contentLabel.textColor = Color_Gray2;
        _contentLabel.font = FONT(12);
        _contentLabel.numberOfLines = 0;
    }
    
    return _contentLabel;
}

@end
