//
//  PostTextCell.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostTextCell.h"
#import "PostModel.h"
#import "PostVoteView.h"
#import "PostManager.h"

#define LINESPACE 4.f
#define PADDING 20.f
#define SINGLE_LINE_HEIGHT 22.f
#define CONTENT_WIDTH SCREEN_WIDTH - PADDING - 70
#define MORE_HEIGHT 28

@interface PostTextCell ()

@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) PostVoteView *postVoteView;
@property (nonatomic, strong) UILabel *readMoreLabel;

@end

@implementation PostTextCell

- (void)drawCell{
    
    self.backgroundColor = Color_White;
    [self addSubview:self.contentLabel];
    [self addSubview:self.postVoteView];
    [self addSubview:self.readMoreLabel];
}

- (void)reloadData{
    
    if ( self.cellData ) {
        
        NSDictionary *data = (NSDictionary *)self.cellData;
        
        PostModel *post = (PostModel *)[data objectForKey:@"post"];
        BOOL rowLimit = [[data objectForKey:@"rowLimit"] boolValue];
        
        NSRange range = NSMakeRange(0, post.content.length);
        
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"#[^#]+?#" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRange matchRange = [regularExpression rangeOfFirstMatchInString:post.content options:0 range:range];
        
        NSMutableAttributedString *attributedText = [PostTextCell builtContentAttributedString:post.content];
        
        if ( matchRange.location == 0 ) {
            [attributedText yy_setColor:Color_Green1 range:matchRange];
            [attributedText yy_setFont:BOLD_FONT(14) range:matchRange];
            
            YYTextHighlight *highlight = [YYTextHighlight new];
            [attributedText yy_setTextHighlight:highlight range:matchRange];
        }
        
        YYTextLayout *textLayout = [PostTextCell builtTextLayout:attributedText withMaxRow:rowLimit ? 10 : 0];
        
        self.contentLabel.attributedText = attributedText;
        self.contentLabel.textLayout = textLayout;
        self.contentLabel.size = textLayout.textBoundingSize;
        
        self.postVoteView.vote = post.vote;
        self.postVoteView.voteUp = post.voteUp;
        self.postVoteView.voteDown = post.voteDown;
        self.postVoteView.postId = post.id;
        [self.postVoteView refresh];
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    if ( cellData ) {
        
        NSDictionary *data = (NSDictionary *)cellData;
        
        PostModel *post = (PostModel *)[data objectForKey:@"post"];
        BOOL rowLimit = [[data objectForKey:@"rowLimit"] boolValue];
        
        NSMutableAttributedString *attributedText = [self builtContentAttributedString:post.content];
        
        YYTextLayout *textLayout = [PostTextCell builtTextLayout:attributedText withMaxRow:rowLimit ? 10 : 0];
        
        CGFloat contentHeight = ceil(textLayout.textBoundingSize.height);
        
        CGFloat height = 10 + ( contentHeight < 55 ? 55 : contentHeight ) + 10;
        
        if (rowLimit && 10 == textLayout.rowCount ) {
            YYTextLayout *noRowLimitLayout = [PostTextCell builtTextLayout:attributedText withMaxRow:0];
//            DBG(@"文本%@ 行数%ld 无限制行数%ld", post.content, textLayout.rowCount, noRowLimitLayout.rowCount);
            
            if ( noRowLimitLayout.rowCount > 10 ) {
                height += MORE_HEIGHT;
            }
            
        }
        
        return height;
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

- (PostVoteView *)postVoteView
{
    if ( !_postVoteView ) {
        _postVoteView = [[PostVoteView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70 , 10, 70, 55)];
    }
    return _postVoteView;
}

- (UILabel *)readMoreLabel
{
    if ( !_readMoreLabel ) {
        _readMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, 0, 0, 0)];
        _readMoreLabel.textColor = Color_Green1;
        _readMoreLabel.font = FONT(12);
        _readMoreLabel.text = @"查看全文";
        [_readMoreLabel sizeToFit];
        _readMoreLabel.hidden = YES;
    }
    
    return _readMoreLabel;
}

#pragma mark - Private Methods

- (void)highlightTapWithContainerView:(UIView *)containerView text:(NSAttributedString *)text range:(NSRange)range rect:(CGRect)rect
{
//    DBG(@"highlightTap %@ %ld %ld", text.string, range.length, range.location);
    
    NSString *title = [[text.string substringWithRange:range] stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    [[TTNavigationService sharedService] openUrl:[NSString stringWithFormat:@"jump://title_post?title=%@", title]];
}

#pragma mark - Custom Methods

+ (NSMutableAttributedString *)builtContentAttributedString:(NSString *)content
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:content];
    attributedText.yy_font = FONT(14);
    attributedText.yy_color = Color_Gray2;
    attributedText.yy_lineSpacing = LINESPACE;
    
    return attributedText;
}

+ (YYTextLayout *)builtTextLayout:(NSMutableAttributedString *)attributedString withMaxRow:(NSInteger)maxRow
{
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(CONTENT_WIDTH, CGFLOAT_MAX);
    container.maximumNumberOfRows = maxRow;
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
    
    return textLayout;
}

@end
