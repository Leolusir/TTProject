//
//  PostTextCell.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostTextCell.h"
#import "PostModel.h"

@interface PostTextCell ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation PostTextCell

- (void)drawCell{
    self.backgroundColor = Color_Red1;
}

- (void)reloadData{
    
    if ( self.cellData ) {
        
        PostModel *post = (PostModel *)self.cellData;
        
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    PostModel *post = (PostModel *)cellData;
    
    CGSize size = [post.content sizeWithUIFont:FONT(14) forWidth:SCREEN_WIDTH - 20 - 90];
    
    return ceil(size.height);
}

#pragma mark - Getters And Setters

@end
