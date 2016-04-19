//
//  PostVoteView.m
//  TTProject
//
//  Created by Ivan on 16/4/17.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostVoteView.h"
#import "PostRequest.h"

@interface PostVoteView ()

@property (nonatomic, strong) UIButton *voteUpButton;
@property (nonatomic, strong) UIButton *voteDownButton;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation PostVoteView

#pragma mark - Override Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.voteUpButton];
        [self addSubview:self.voteDownButton];
        [self addSubview:self.countLabel];
        
    }
    
    return self;
}

#pragma mark - Custom Methods

- (void)refresh
{
    self.voteDownButton.selected = NO;
    self.voteUpButton.selected = NO;
    [self.voteUpButton setImage:[UIImage imageNamed:@"icon_vote_up_normal"] forState:UIControlStateHighlighted];
    [self.voteDownButton setImage:[UIImage imageNamed:@"icon_vote_down_normal"] forState:UIControlStateHighlighted];
    
    if( 1 == self.vote ){
        self.voteUpButton.selected = YES;
        [self.voteUpButton setImage:[UIImage imageNamed:@"icon_vote_up_selected"] forState:UIControlStateHighlighted];
    } else if( 2 == self.vote){
        self.voteDownButton.selected = YES;
        [self.voteDownButton setImage:[UIImage imageNamed:@"icon_vote_down_selected"] forState:UIControlStateHighlighted];
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld", self.voteUp - self.voteDown];
    
}

#pragma mark - Getters And Setters

- (UIButton *)voteUpButton
{
    if ( !_voteUpButton ) {
        _voteUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voteUpButton.frame = CGRectMake(0.0f, 0.0f, self.width, self.height / 2);
        _voteUpButton.imageEdgeInsets = UIEdgeInsetsMake( -self.height / 4, 0, 0, 0);
        [_voteUpButton setImage:[UIImage imageNamed:@"icon_vote_up_normal"] forState:UIControlStateNormal];
        [_voteUpButton setImage:[UIImage imageNamed:@"icon_vote_up_normal"] forState:UIControlStateHighlighted];
        [_voteUpButton setImage:[UIImage imageNamed:@"icon_vote_up_selected"] forState:UIControlStateSelected];
        [_voteUpButton addTarget:self action:@selector(handleVoteUpButton) forControlEvents:UIControlEventTouchUpInside];
        [_voteUpButton setExclusiveTouch:YES];
    }
    
    return _voteUpButton;
}

- (UIButton *)voteDownButton
{
    if ( !_voteDownButton ) {
        _voteDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voteDownButton.frame = CGRectMake(0.0f, 0.0f, self.width, self.height / 2);
        _voteDownButton.imageEdgeInsets = UIEdgeInsetsMake(self.height / 4, 0, 0, 0);
        [_voteDownButton setImage:[UIImage imageNamed:@"icon_vote_down_normal"] forState:UIControlStateNormal];
        [_voteDownButton setImage:[UIImage imageNamed:@"icon_vote_down_normal"] forState:UIControlStateHighlighted];
        [_voteDownButton setImage:[UIImage imageNamed:@"icon_vote_down_selected"] forState:UIControlStateSelected];
        [_voteDownButton addTarget:self action:@selector(handleVoteDownButton) forControlEvents:UIControlEventTouchUpInside];
        [_voteDownButton setExclusiveTouch:YES];
        _voteDownButton.bottom = self.height;
    }
    
    return _voteDownButton;
}

- (UILabel *)countLabel
{
    if ( !_countLabel ) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _countLabel.text = @"0";
        _countLabel.font = BOLD_FONT(16);
        _countLabel.textColor = Color_Green1;
        [_countLabel sizeToFit];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.width = self.width;
        _countLabel.centerY = self.height / 2;
    }
    return _countLabel;
}

#pragma mark - Event Response

- (void)handleVoteUpButton
{
    DBG(@"handleVoteUpButton");
    
    NSInteger oriVote = self.vote;
    NSInteger oriVoteUp = self.voteUp;
    NSInteger oriVoteDown = self.voteDown;
    
    if( 1 == self.vote ){
        self.vote = 0;
        self.voteUp -= 1;
    } else if( 2 == self.vote){
        self.vote = 1;
        self.voteUp += 1;
        self.voteDown -= 1;
    } else {
        self.vote = 1;
        self.voteUp += 1;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:[TTUserService sharedService].id forKey:@"userId"];
    [params setSafeObject:self.postId forKey:@"postId"];
    [params setSafeObject:@(oriVote) forKey:@"oriVote"];
    [params setSafeObject:@(self.vote) forKey:@"vote"];
    
    weakify(self);
    
    [PostRequest voteWithParams:params success:^{
        
        strongify(self);
        
        [self refresh];
        
    } failure:^(StatusModel *status) {
        
        self.vote = oriVote;
        self.voteUp = oriVoteUp;
        self.voteDown = oriVoteDown;
        
    }];
    
}

- (void)handleVoteDownButton
{
    DBG(@"handleVoteDownButton");
    
    NSInteger oriVote = self.vote;
    NSInteger oriVoteUp = self.voteUp;
    NSInteger oriVoteDown = self.voteDown;
    
    if( 1 == self.vote ){
        self.vote = 2;
        self.voteUp -= 1;
        self.voteDown += 1;
    } else if( 2 == self.vote){
        self.vote = 0;
        self.voteDown -= 1;
    } else {
        self.vote = 2;
        self.voteDown += 1;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:[TTUserService sharedService].id forKey:@"userId"];
    [params setSafeObject:self.postId forKey:@"postId"];
    [params setSafeObject:@(oriVote) forKey:@"oriVote"];
    [params setSafeObject:@(self.vote) forKey:@"vote"];
    
    weakify(self);
    
    [PostRequest voteWithParams:params success:^{
        
        strongify(self);
        
        [self refresh];
        
    } failure:^(StatusModel *status) {
        
        self.vote = oriVote;
        self.voteUp = oriVoteUp;
        self.voteDown = oriVoteDown;
        
    }];
}

@end
