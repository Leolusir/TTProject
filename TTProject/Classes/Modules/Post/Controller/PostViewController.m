//
//  PostViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostViewController.h"
#import "TTGalleryViewController.h"

#import "MessageModel.h"
#import "PostTextCell.h"
#import "PostImageCell.h"
#import "MessageCell.h"
#import "MessageRequest.h"

@interface PostViewController () <UITextViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *messageCellHeightCache;
@property (nonatomic, strong) NSMutableArray<MessageModel> *messages;

@property (nonatomic, strong) UIView *replyBgView;
@property (nonatomic, strong) UITextView *replyTextView;
@property (nonatomic, strong) UILabel *replyPlaceholderLabel;
@property (nonatomic, strong) UIButton *replyButton;

@end

@implementation PostViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"详情";
    
    self.view.backgroundColor = Color_Gray5;
    
    [self addReplyView];
    
    [self initData];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Override Methods

- (void)addTableView
{
    [super addTableView];
    
    self.tableView.height = SCREEN_HEIGHT - NAVBAR_HEIGHT - 60;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.tableView addGestureRecognizer:gesture];
    
    gesture.cancelsTouchesInView = NO;

}

#pragma mark - Private Methods

- (void)initData
{
    self.loadingType = LoadingTypeInit;
    
    self.messages = [NSMutableArray<MessageModel> array];
    self.messageCellHeightCache = [NSMutableDictionary dictionary];
    self.wp = @"0";
    
    [self loadData];
}

- (void)loadData
{
    if ( IsEmptyString(self.userIdOne) || IsEmptyString(self.userIdTwo) || [self.userIdOne isEqualToString:self.userIdTwo]) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:self.postId forKey:@"postId"];
    [params setSafeObject:self.userIdOne forKey:@"userIdTwo"];
    [params setSafeObject:self.userIdTwo forKey:@"userIdOne"];
    [params setSafeObject:[TTUserService sharedService].id forKey:@"selfUserId"];
    
    
    if ( LoadingTypeLoadMore == self.loadingType ) {
        [params setSafeObject:self.wp forKey:@"wp"];
    } else {
        [params setSafeObject:@"0" forKey:@"wp"];
    }
    
    weakify(self);
    
    [MessageRequest getMessagesWithParams:params success:^(MessageResultModel *resultModel) {
        
        strongify(self);
        
        self.tableView.showsPullToRefresh = YES;
        
        if (resultModel) {
            
            if ( LoadingTypeLoadMore == self.loadingType ) {
                [self finishLoadMore];
            } else {
                [self finishRefresh];
                [self.messages removeAllObjects];
                [self.messageCellHeightCache removeAllObjects];
            }
            
            [self.messages addObjectsFromSafeArray:resultModel.messages];
            
            self.wp = resultModel.wp;
            self.post = resultModel.post;
            
            if( resultModel.isEnd ){
                self.tableView.showsInfiniteScrolling = NO;
            } else {
                self.tableView.showsInfiniteScrolling = YES;
            }
            
            [self reloadData];
            
        }
        
        
    } failure:^(StatusModel *status) {
        
        DBG(@"%@", status);
        
        strongify(self);
        
        [self showNotice:status.msg];
        
        if ( LoadingTypeLoadMore == self.loadingType ) {
            [self finishLoadMore];
        } else {
            self.tableView.showsPullToRefresh = YES;
            [self finishRefresh];
        }
        
    }];
    
}

- (CGFloat)getMessageCellHeight:(MessageModel *)message
{
    
    CGFloat height = 0;
    
    if ( [self.messageCellHeightCache objectForKey:message.id] ) {
        height = [[self.messageCellHeightCache objectForKey:message.id] floatValue];
    } else {
        height = [MessageCell heightForCell:message];
        [self.messageCellHeightCache setSafeObject:@(height) forKey:message.id];
    }
    
    return height;
}

- (void)addReplyView
{
    self.replyBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    self.replyBgView.backgroundColor = Color_White;
    self.replyBgView.bottom = self.view.height;
    [self.view addSubview:self.replyBgView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LINE_WIDTH)];
    lineView.backgroundColor = Color_Green1;
    [self.replyBgView addSubview:lineView];
    
    self.replyButton = [UIButton buttonWithImage:[UIImage imageNamed:@"icon_reply"] highlightedImage:[UIImage imageNamed:@"icon_reply"] target:self action:@selector(handleReplyButton) forControlEvents:UIControlEventTouchUpInside];
    self.replyButton.centerY = self.replyBgView.height / 2;
    self.replyButton.right = SCREEN_WIDTH;
    [self.replyBgView addSubview:self.replyButton];
    
    self.replyTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 20 - self.replyButton.width - 10, 32)];
    self.replyTextView.centerY = self.replyBgView.height / 2;
//    self.replyTextField.placeholder = @"回复TA";
    self.replyTextView.delegate = self;
    self.replyTextView.font = FONT(14);
    self.replyTextView.textColor = Color_Gray2;
    self.replyTextView.tintColor = Color_Green1;
    [self.replyBgView addSubview:self.replyTextView];
    
    self.replyPlaceholderLabel = [[UILabel alloc] init];
    self.replyPlaceholderLabel.font = FONT(14);
    self.replyPlaceholderLabel.textColor = Color_Gray3;
    self.replyPlaceholderLabel.text = @"回复TA";
    [self.replyPlaceholderLabel sizeToFit];
    self.replyPlaceholderLabel.centerY = self.replyBgView.height / 2;
    self.replyPlaceholderLabel.left = 25;
    [self.replyBgView addSubview:self.replyPlaceholderLabel];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 == section ) {
        return 2;
    }
    
    return self.messages.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( 0 == indexPath.section ) {
        
        if ( self.post ) {
            if ( 0 == indexPath.row ) {
                
                PostImageCell *cell = [PostImageCell dequeueReusableCellForTableView:tableView];
                cell.cellData = self.post.imageUrl;
                [cell reloadData];
                return cell;
                
            } else if ( 1 == indexPath.row) {
                
                PostTextCell *cell = [PostTextCell dequeueReusableCellForTableView:tableView];
                cell.cellData = @{@"post":self.post, @"rowLimit":@NO};
                [cell reloadData];
                return cell;
                
            }
            
        }
        
    } else {
    
        if ( indexPath.row > 0 ) {
            
            MessageModel *message = [self.messages safeObjectAtIndex:indexPath.row - 1];
            
            if (message) {
                MessageCell *cell = [MessageCell dequeueReusableCellForTableView:tableView];
                cell.cellData = message;
                [cell reloadData];
                return cell;
            }
            
        }
        
    }
    
    BaseTableViewCell *cell = [BaseTableViewCell dequeueReusableCellForTableView:tableView];
    [cell reloadData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if ( 0 == indexPath.section ) {
        
        if ( self.post ) {
            
            if ( 0 == indexPath.row ) {
                
                height = [PostImageCell heightForCell:self.post.imageUrl];
                
            } else if ( 1 == indexPath.row) {
                
                height = [PostTextCell heightForCell:@{@"post":self.post, @"rowLimit":@NO}];
                
            }
            
        }
        
        
    } else {
        
        if ( 0 == indexPath.row ) {
            return 10;
        } else {
            MessageModel *message = [self.messages safeObjectAtIndex:indexPath.row - 1];
            
            if ( message ) {
                height = [self getMessageCellHeight:message];
            }
        }
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( 0 == indexPath.section ) {
        
        if ( 0 == indexPath.row ) {
            
            TTGalleryViewController *galleryViewController = [[TTGalleryViewController alloc] init];
            galleryViewController.imageSrcs = @[[NSString stringWithFormat:@"%@-l",self.post.imageUrl]];
            [[[ApplicationEntrance shareEntrance] currentNavigationController] pushViewController:galleryViewController animated:YES];
        }
    }
}

#pragma mark - TTErrorTipsViewDelegate

- (void) errorTipsViewBeginRefresh:(TTErrorTipsView *)tipsView
{
    [self initData];
}

#pragma mark - Event Response

- (void)hiddenKeyboard
{
    [self.view endEditing:YES];
}

- (void)handleReplyButton
{
    DBG(@"handleReplyButton");
    
    NSString *content = self.replyTextView.text;
    
    if ( 0 == content.length ) {
        [self showNotice:@"请输入内容"];
        return;
    }
    
    [self.view endEditing:YES];
    
    self.replyButton.enabled = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:self.postId forKey:@"postId"];
    [params setSafeObject:self.userIdOne forKey:@"userIdTwo"];
    [params setSafeObject:self.userIdTwo forKey:@"userIdOne"];
    [params setSafeObject:[TTUserService sharedService].id forKey:@"userId"];
    [params setSafeObject:content forKey:@"content"];
    
    weakify(self);
    
    [MessageRequest sendMessagesWithParams:params success:^(MessageSendResultModel *resultModel) {
        
        strongify(self);
        
        [self.messages insertObject:resultModel.message atIndex:0];
        self.replyTextView.text = @"";
        [self reloadData];
        
        self.replyButton.enabled = YES;
        
        NSDictionary *userInfo = @{@"message" : resultModel.message};
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_APP_MESSAGE_REPLY_SUCCESS object:nil userInfo:userInfo];
        
    } failure:^(StatusModel *status) {
        
        DBG(@"%@", status);
        
        strongify(self);
        
        self.replyButton.enabled = YES;
        
        [self showNotice:status.msg];
        
    }];
    
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat bottom = self.replyBgView.bottom;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(textView.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    
    self.replyTextView.height = newSize.height > 100 ? 100 : newSize.height;
    self.replyBgView.height = self.replyTextView.height + 28;
    self.replyBgView.bottom = bottom;
    
    if ( self.replyTextView.text.length > 0 ) {
        self.replyPlaceholderLabel.hidden = YES;
    } else {
        self.replyPlaceholderLabel.hidden = NO;
    }
}

#pragma mark - Observing Methods

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)notification {
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    weakify(self);
    [UIView animateWithDuration:0.2f animations:^{
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        strongify(self);
        self.replyBgView.bottom = self.view.height - keyboardHeight;
    }];
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notification {
    
    weakify(self);
    [UIView animateWithDuration:0.2f animations:^{
        strongify(self);
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        self.replyBgView.bottom = self.view.height;
    }];
}

@end
