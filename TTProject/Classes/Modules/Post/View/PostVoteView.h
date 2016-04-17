//
//  PostVoteView.h
//  TTProject
//
//  Created by Ivan on 16/4/17.
//  Copyright © 2016年 ivan. All rights reserved.
//

@interface PostVoteView : UIView

@property (nonatomic, assign) NSInteger voteUp;
@property (nonatomic, assign) NSInteger voteDown;
@property (nonatomic, assign) NSInteger vote;

- (void)reloadWithVote:(NSInteger)vote voteUp:(NSInteger)voteUp voteDown:(NSInteger)voteDown;

@end