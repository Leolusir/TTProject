//
//  PostImageCell.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostImageCell.h"

#define IMAGE_HEIGHT SCREEN_WIDTH

@interface PostImageCell ()

@property (nonatomic, strong) UIImageView *postImageView;

@end

@implementation PostImageCell

- (void)drawCell{
    
    self.backgroundColor = Color_White;
    [self addSubview:self.postImageView];
    
}

- (void)reloadData{
    
    if ( self.cellData ) {

        [self.postImageView setOnlineImage:(NSString *)self.cellData];
        
//        weakify(self);
//        [self.postImageView setOnlineImage:(NSString *)self.cellData complete:^(UIImage *image) {
//            strongify(self);
//            self.postImageView.contentMode = UIViewContentModeScaleAspectFit;
//        }];
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    if (cellData) {
        return IMAGE_HEIGHT;
    }
    return 0;
}

#pragma mark - Getters And Setters

- (UIImageView *)postImageView
{
    if ( !_postImageView ) {
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IMAGE_HEIGHT)];
    }
    
    return _postImageView;
}

@end
