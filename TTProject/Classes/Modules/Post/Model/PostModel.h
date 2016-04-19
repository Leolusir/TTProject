//
//  PostModel.h
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"
#import "TitleModel.h"

@protocol PostModel

@end

@interface PostModel : BaseModel

@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) TitleModel<Optional> *title;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *aoi;
@property (nonatomic, assign) NSInteger voteUp;
@property (nonatomic, assign) NSInteger voteDown;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger vote; //0 => 啥也没 1 => 赞  2 => 踩
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger member;
@property (nonatomic, strong) NSString<Optional> *imageUrl;

@end
