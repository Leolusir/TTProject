//
//  RecordViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/27.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "RecordViewController.h"

#import "PostViewController.h"

#import "RecordModel.h"
#import "MessageModel.h"
#import "MessageRequest.h"
#import "RecordCell.h"

@interface RecordViewController ()

@property (nonatomic, strong) NSMutableArray<RecordModel> *records;
@property (nonatomic, strong) NSString *recordIdForDelete;

@end

@implementation RecordViewController

#pragma mark - Life Cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabbarItem = [[TTTabbarItem alloc] initWithTitle:@"消息" titleColor:Color_Gray1 selectedTitleColor:Color_Green1 icon:[UIImage imageNamed:@"icon_tabbar_message_normal"] selectedIcon:[UIImage imageNamed:@"icon_tabbar_message_selected"]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived) name:kNOTIFY_APP_NEW_MESSAGE_RECEIVED object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息";
    
    [self addNavigationBar];
    
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignIn) name:kNOTIFY_APP_USER_SIGNIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignOut) name:kNOTIFY_APP_USER_SIGNOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReplySuccess:) name:kNOTIFY_APP_MESSAGE_REPLY_SUCCESS object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabbarItem showBadge:NO];
}

#pragma mark - Override Methods

- (void)addTableView
{
    [super addTableView];
    
    self.tableView.top = NAVBAR_HEIGHT;
    self.tableView.height = SCREEN_HEIGHT - NAVBAR_HEIGHT - TABBAR_HEIGHT;
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    longPress.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPress];
    
}

#pragma mark - Private Methods

- (void)initData
{
    self.loadingType = LoadingTypeInit;
    
    self.records = [NSMutableArray<RecordModel> array];
    
    [self loadData];
}

- (void)loadData
{
    if (![TTUserService sharedService].isLogin) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:[TTUserService sharedService].id forKey:@"userId"];
    
    
    if ( LoadingTypeLoadMore == self.loadingType ) {
        [params setSafeObject:self.wp forKey:@"wp"];
    } else {
        [params setSafeObject:@"0" forKey:@"wp"];
    }
    
    if ( LoadingTypeInit == self.loadingType ) {
        self.tableView.showsPullToRefresh = YES;
//        [self startRefresh];
    }
    
    weakify(self);
    
    [MessageRequest getRecordsWithParams:params success:^(RecordListResultModel *resultModel) {
        
        strongify(self);
        
        self.tableView.showsPullToRefresh = YES;
        
        if (resultModel) {
            
            if ( LoadingTypeLoadMore == self.loadingType ) {
                [self finishLoadMore];
            } else {
                [self finishRefresh];
                [self.records removeAllObjects];
            }
            
            [self.records addObjectsFromArray:resultModel.records];
            
            self.wp = resultModel.wp;
            
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
            [self finishRefresh];
        }
        
    }];
    
}

#pragma mark - Event Response

-(void)cellLongPress:(UILongPressGestureRecognizer *)gesture
{
    
    if( gesture.state == UIGestureRecognizerStateBegan )
    {
        CGPoint point = [gesture locationInView:self.tableView];
        
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if(indexPath == nil) return ;
        
        RecordModel *record = [self.records safeObjectAtIndex:indexPath.row];
        
        if (record) {
            
            DBG(@"%@", record);
            self.recordIdForDelete = record.id;
            TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:nil message:@"删除对话并拉黑对方" containerView:nil delegate:self confirmButtonTitle:@"确定" otherButtonTitles:@[@"取消"]];
            [alertView show];
        }
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecordModel *record = [self.records safeObjectAtIndex:indexPath.row];
    
    if (record) {
        
        RecordCell *cell = [RecordCell dequeueReusableCellForTableView:tableView];
        cell.cellData = record;
        [cell reloadData];
        return cell;
        
    }
    
    BaseTableViewCell *cell = [BaseTableViewCell dequeueReusableCellForTableView:tableView];
    [cell reloadData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 0;
    
    RecordModel *record = [self.records safeObjectAtIndex:indexPath.row];
    
    if (record) {
        
        height = [RecordCell heightForCell:record];
        
    }
    
    return height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordModel *record = [self.records safeObjectAtIndex:indexPath.row];
    
    if (record) {
        
        DBG(@"%@", record);
        
        TTNavigationController *navigationController = [[ApplicationEntrance shareEntrance] currentNavigationController];
        PostViewController *vc = [[PostViewController alloc] init];
        
        vc.postId = record.postId;
        vc.userIdOne = record.userIdOne;
        vc.userIdTwo = record.userIdTwo;
        
        [navigationController pushViewController:vc animated:YES];
        
        record.status = 0;
        [self reloadData];
        
    }
    
}

#pragma mark - TTErrorTipsViewDelegate

- (void) errorTipsViewBeginRefresh:(TTErrorTipsView *)tipsView
{
    [self initData];
}

#pragma mark - Notification Methods

- (void)userSignIn
{
    [self initData];
}

- (void)userSignOut
{
    [self.records removeAllObjects];
    [self reloadData];
}

- (void)messageReplySuccess:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    MessageModel *message = [userInfo objectForKey:@"message"];
    
    RecordModel *newRecord = nil;
    
    if ( message ) {
        
        for (RecordModel *record in self.records) {
            
            if ( [record.postId isEqualToString:message.postId]) {
                
                [self.records removeObject:record];
                newRecord = record;
                break;
            }
            
        }
        
        if ( newRecord ) {
            newRecord.content = message.content;
            newRecord.createTime = @"刚刚";
            [self.records insertObject:newRecord atIndex:0];
            
            [self reloadData];
        }
        
    }
    
}

- (void)newMessageReceived
{
    [self initData];
    
    [self.tabbarItem showBadge:YES];
}

#pragma mark - TTAlertViewDelegate

- (void)alertView:(TTAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    DBG(@"%ld", (long)buttonIndex);
    
    if ( 0 == buttonIndex ) {
        
        DBG(@"删删删");
        
        weakify(self);
        
        [MessageRequest deleteRecordWithId:self.recordIdForDelete success:^{
            
            strongify(self);
            
            for (RecordModel *record in self.records) {
                
                if ( [self.recordIdForDelete isEqualToString:record.id] ) {
                    [self.records removeObject:record];
                    [self reloadData];
                    break;
                }
                
            }
            
            self.recordIdForDelete = @"";
            
        } failure:^(StatusModel *status) {
            
            strongify(self);
            
            self.recordIdForDelete = @"";
            
            [self showNotice:@"删除失败"];
            
        }];
        
    }
    
}

@end
