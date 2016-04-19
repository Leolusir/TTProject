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
@property (nonatomic, strong) NSString *postId;

- (void)refresh;

@end