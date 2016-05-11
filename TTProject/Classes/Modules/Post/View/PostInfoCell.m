//
//  PostInfoCell.m
//  TTProject
//
//  Created by Ivan on 16/5/11.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostInfoCell.h"
#import "PostModel.h"

@interface PostInfoCell ()

@property (nonatomic, strong) UIImageView *createTimeIconImageView;
@property (nonatomic, strong) UIImageView *memberIconImageView;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *memberLabel;

@end

@implementation PostInfoCell

- (void)drawCell{
    
    self.backgroundColor = Color_White;
    [self addSubview:self.createTimeIconImageView];
    [self addSubview:self.memberIconImageView];
    [self addSubview:self.createTimeLabel];
    [self addSubview:self.memberLabel];
}

- (void)reloadData{
    
    if ( self.cellData ) {
        
        PostModel *post = (PostModel *)self.cellData;
        
        self.createTimeLabel.text = post.createTime;
        [self.createTimeLabel sizeToFit];
        self.createTimeLabel.centerY = 15;
        self.createTimeLabel.centerX = SCREEN_WIDTH / 4 + 10;
        
        self.createTimeIconImageView.centerY = 15;
        self.createTimeIconImageView.right = self.createTimeLabel.left - 5;
        
        self.memberLabel.text = [NSString stringWithFormat:@"%ld人参与", (long)post.member];
        [self.memberLabel sizeToFit];
        self.memberLabel.centerY = 15;
        self.memberLabel.centerX = SCREEN_WIDTH / 4 * 3 + 10;
        
        self.memberIconImageView.centerY = 15;
        self.memberIconImageView.right = self.memberLabel.left - 5;
        
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    if ( cellData ) {
        
        return 30;
    }
    
    return 0;
}

#pragma mark - Getters And Setters

- (UILabel *)createTimeLabel
{
    if ( !_createTimeLabel ) {
        _createTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _createTimeLabel.textColor = Color_Gray3;
        _createTimeLabel.font = FONT(10);
    }
    
    return _createTimeLabel;
}

- (UIImageView *)createTimeIconImageView
{
    if ( !_createTimeIconImageView ) {
        _createTimeIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_post_time"]];
    }
    
    return _createTimeIconImageView;
}

- (UILabel *)memberLabel
{
    if ( !_memberLabel ) {
        _memberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _memberLabel.textColor = Color_Gray3;
        _memberLabel.font = FONT(10);
    }
    
    return _memberLabel;
}

- (UIImageView *)memberIconImageView
{
    if ( !_memberIconImageView ) {
        _memberIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_post_member"]];
    }
    
    return _memberIconImageView;
}

@end
