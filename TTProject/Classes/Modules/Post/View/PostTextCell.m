//
//  PostTextCell.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostTextCell.h"
#import "PostModel.h"
#import "TTTAttributedLabel.h"
#import "PostVoteView.h"

#define LINESPACE 4.f
#define PADDING 20.f
#define SINGLE_LINE_HEIGHT 22.f

@interface PostTextCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
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
        
        self.contentLabel.text = post.content;
        [self.contentLabel addLinkToURL:[NSURL URLWithString:@"http://baidu.com"] withRange:matchRange];
        
        [self.contentLabel sizeToFit];
        self.contentLabel.width = SCREEN_WIDTH - PADDING - 90;
        
        CGFloat contentHeight = ceil(self.contentLabel.height) + 10 + 12;
        
        CGFloat cellHeight = 10 + ( contentHeight < 55 ? 55 : contentHeight ) + 15;
        self.countLabel.text = [NSString stringWithFormat:@"%@    %ld条评论    %ld人参与",post.createTime, post.commentCount, post.member];//@"10分钟前   10条评论   100人参与";
        [self.countLabel sizeToFit];
        self.countLabel.bottom = cellHeight - 15;
        
        [self.postVoteView reloadWithVote:post.vote voteUp:post.voteUp voteDown:post.voteDown];
    }
    
}

+ (CGFloat)heightForCell:(id)cellData {
    
    PostModel *post = (PostModel *)cellData;
    
    CGSize size = [post.content sizeWithUIFont:FONT(14) lineSpacing:LINESPACE forWidth:SCREEN_WIDTH - PADDING - 90];
    
    CGFloat contentHeight = ceil(size.height) + 10 + 12;
    
    return 10 + ( contentHeight < 55 ? 55 : contentHeight ) + 15;
}

#pragma mark - Getters And Setters

- (TTTAttributedLabel *)contentLabel
{
    if ( !_contentLabel ) {
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(PADDING, 10, SCREEN_WIDTH - PADDING - 90, 0)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = Color_Gray2;
        _contentLabel.font = FONT(14);
        _contentLabel.delegate = self;
        _contentLabel.lineSpacing = LINESPACE;
        _contentLabel.highlightedTextColor = Color_Green1;
        
        NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
        [linkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [linkAttributes setValue:(__bridge id)Color_Green1.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)BOLD_FONT(14).fontName, BOLD_FONT(14).pointSize, NULL);
        if (font) {
            //设置可点击文本的大小
            [linkAttributes setValue:(__bridge id)font forKey:(NSString *)kCTFontAttributeName];
            CFRelease(font);
        }
        _contentLabel.linkAttributes = linkAttributes;
        _contentLabel.activeLinkAttributes = linkAttributes;
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

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    DBG(@"link: %@", url);
    [[TTNavigationService sharedService] openUrl:url.absoluteString];
}

@end
