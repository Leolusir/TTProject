//
//  PostImageCell.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostImageCell.h"

#define MAX_IMAGE_HEIGHT SCREEN_WIDTH

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

        NSDictionary *data = (NSDictionary *)self.cellData;
        
        self.postImageView.height = [PostImageCell heightForCell:self.cellData];
        weakify(self);
        [self.postImageView setOnlineImage:[NSString stringWithFormat:@"%@-s",data[@"imageSrc"]] complete:^(UIImage *image) {
            strongify(self);
            self.postImageView.contentMode = UIViewContentModeScaleAspectFit;
        }];
        
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    if (cellData) {
        
        NSDictionary *data = (NSDictionary *)cellData;
        CGFloat imageWidth = [data[@"w"] floatValue];
        CGFloat imageHeight = [data[@"h"] floatValue];
        
        CGFloat cellHeight = imageHeight / imageWidth * SCREEN_WIDTH;
        
        return cellHeight > MAX_IMAGE_HEIGHT ? MAX_IMAGE_HEIGHT : cellHeight;
    }
    return 0;
}

#pragma mark - Getters And Setters

- (UIImageView *)postImageView
{
    if ( !_postImageView ) {
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAX_IMAGE_HEIGHT)];
    }
    
    return _postImageView;
}

@end
