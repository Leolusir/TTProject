//
//  UserInfoCell.m
//  TTProject
//
//  Created by Ivan on 16/4/29.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "UserInfoCell.h"

@interface UserInfoCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *astroLabel;

@end

@implementation UserInfoCell

- (void)drawCell{
    
    self.backgroundColor = Color_White;
    [self addSubview:self.avatarImageView];
    [self addSubview:self.ageLabel];
    [self addSubview:self.astroLabel];
    
}

- (void)reloadData{
    
    if ( self.cellData ) {
        
        NSDictionary *data = (NSDictionary *)self.cellData;
        
        [self.avatarImageView setOnlineImage:@"http://oss2.lanlanlife.com/16f5c07ff14403e255a6708efbf8582b_288x288.png"];
        
        self.ageLabel.text = data[@"age"];
        self.astroLabel.text = data[@"astro"];
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    return 200;
}

#pragma mark - Getters And Setters

- (UIImageView *)avatarImageView
{
    if ( !_avatarImageView ) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35, 96, 96)];
        _avatarImageView.centerX = SCREEN_WIDTH / 2;
        _avatarImageView.layer.cornerRadius = 48.f;
    }
    
    return _avatarImageView;
}

- (UILabel *)ageLabel
{
    if ( !_ageLabel ) {
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _ageLabel.textColor = Color_Gray2;
        _ageLabel.font = FONT(20);
        _ageLabel.textAlignment = NSTextAlignmentRight;
        _ageLabel.text = @"0岁";
        [_ageLabel sizeToFit];
        _ageLabel.left = 0;
        _ageLabel.width = SCREEN_WIDTH / 2 - 10;
        _ageLabel.bottom = 180;
    }
    
    return _ageLabel;
}

- (UILabel *)astroLabel
{
    if ( !_astroLabel ) {
        _astroLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _astroLabel.textColor = Color_Gray2;
        _astroLabel.font = FONT(20);
        _astroLabel.textAlignment = NSTextAlignmentLeft;
        _astroLabel.text = @"座";
        [_astroLabel sizeToFit];
        _astroLabel.width = SCREEN_WIDTH / 2 - 10;
        _astroLabel.right = SCREEN_WIDTH;
        _astroLabel.bottom = 180;
    }
    
    return _astroLabel;
}

@end
