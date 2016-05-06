//
//  PostTextCell.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostTextCell.h"
#import "PostModel.h"
#import <YYText/YYText.h>
#import "PostVoteView.h"

#define LINESPACE 4.f
#define PADDING 20.f
#define SINGLE_LINE_HEIGHT 22.f

@interface PostTextCell ()<UITextViewDelegate>

@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) PostVoteView *postVoteView;

@end

@implementation PostTextCell

- (void)drawCell{
    
    self.backgroundColor = Color_White;
    [self addSubview:self.contentLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.postVoteView];
    
}

- (void)reloadData{
    
    if ( self.cellData ) {
        
        PostModel *post = (PostModel *)self.cellData;
        
        NSRange range = NSMakeRange(0, post.content.length);
        
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"#[^#]+?#" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRange matchRange = [regularExpression rangeOfFirstMatchInString:post.content options:0 range:range];
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:post.content];
        attributedText.yy_font = FONT(14);
        attributedText.yy_color = Color_Gray2;
        attributedText.yy_lineSpacing = LINESPACE;
        
        if ( matchRange.location == 0 ) {
            [attributedText yy_setColor:Color_Green1 range:matchRange];
            [attributedText yy_setFont:BOLD_FONT(14) range:matchRange];
            
            YYTextHighlight *highlight = [YYTextHighlight new];
            [attributedText yy_setTextHighlight:highlight range:matchRange];
        }
        
        self.contentLabel.attributedText = attributedText;
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(SCREEN_WIDTH - PADDING - 90, CGFLOAT_MAX);
        container.maximumNumberOfRows = 0;
        YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributedText];
        self.contentLabel.textLayout = textLayout;
        self.contentLabel.size = textLayout.textBoundingSize;
        
        CGFloat contentHeight = ceil(textLayout.textBoundingSize.height) + 10 + 12;
        
        CGFloat cellHeight = 10 + ( contentHeight < 55 ? 55 : contentHeight ) + 15;
        self.countLabel.text = [NSString stringWithFormat:@"%@    %ld人参与",post.createTime, (long)post.member];//@"10分钟前 100人参与";
        [self.countLabel sizeToFit];
        self.countLabel.bottom = cellHeight - 15;
        
        self.postVoteView.vote = post.vote;
        self.postVoteView.voteUp = post.voteUp;
        self.postVoteView.voteDown = post.voteDown;
        self.postVoteView.postId = post.id;
        [self.postVoteView refresh];
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    if ( cellData ) {
        PostModel *post = (PostModel *)cellData;
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:post.content];
        attributedText.yy_font = FONT(14);
        attributedText.yy_color = Color_Gray2;
        attributedText.yy_lineSpacing = LINESPACE;
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(SCREEN_WIDTH - PADDING - 90, CGFLOAT_MAX);
        container.maximumNumberOfRows = 0;
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
        
        CGFloat contentHeight = ceil(layout.textBoundingSize.height) + 10 + 12;
        
        DBG(@"文本%@ 行数%ld", post.content, layout.rowCount);
        
        return 10 + ( contentHeight < 55 ? 55 : contentHeight ) + 15;
    }
    
    return 0;
}

#pragma mark - Getters And Setters

- (YYLabel *)contentLabel
{
    if ( !_contentLabel ) {
        _contentLabel = [[YYLabel alloc] initWithFrame:CGRectMake(PADDING, 10, SCREEN_WIDTH - PADDING - 90, 0)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = FONT(14);
        
        weakify(self);
        _contentLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            strongify(self);
            [self highlightTapWithContainerView:containerView text:text range:range rect:rect];
        };
        
    }
    
    return _contentLabel;
}

- (UILabel *)countLabel
{
    if ( !_countLabel ) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, 0, SCREEN_WIDTH - PADDING * 2, 0)];
        _countLabel.textColor = Color_Gray3;
        _countLabel.font = FONT(10);
    }
    
    return _countLabel;
}

- (PostVoteView *)postVoteView
{
    if ( !_postVoteView ) {
        _postVoteView = [[PostVoteView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70 , 10, 70, 55)];
    }
    return _postVoteView;
}

#pragma mark - Private Methods

- (void)highlightTapWithContainerView:(UIView *)containerView text:(NSAttributedString *)text range:(NSRange)range rect:(CGRect)rect
{
    DBG(@"highlightTap %@ %ld %ld", text.string, range.length, range.location);
    
    NSString *title = [[text.string substringWithRange:range] stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    [[TTNavigationService sharedService] openUrl:[NSString stringWithFormat:@"jump://title_post?title=%@", title]];
}

@end
