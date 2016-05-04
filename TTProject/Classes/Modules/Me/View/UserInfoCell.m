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

@end

@implementation UserInfoCell

- (void)drawCell{
    
    self.backgroundColor = Color_Green1;
    [self addSubview:self.avatarImageView];
    
}

- (void)reloadData{
    
    UIImage *avatarImage = [UIImage imageNamed:[@"m" isEqualToString:[TTUserService sharedService].gender] ? @"seek_boy" : @"seek_girl"];
    
    self.avatarImageView.image = avatarImage;
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    return 200;
}

#pragma mark - Getters And Setters

- (UIImageView *)avatarImageView
{
    if ( !_avatarImageView ) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _avatarImageView.centerX = SCREEN_WIDTH / 2;
        _avatarImageView.centerY = 100;
    }
    
    return _avatarImageView;
}

@end
