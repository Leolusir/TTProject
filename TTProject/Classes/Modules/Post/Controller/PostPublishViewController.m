//
//  PostPublishViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostPublishViewController.h"
#import "TitleAddViewController.h"
#import "TTHighlightTextView.h"
#import "PostRequest.h"
#import <QiniuSDK.h>
#import <YYText/YYText.h>
#import "SKTopicParser.h"

@interface PostPublishViewController () <UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YYTextViewDelegate>

@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) UIButton *addTitleButton;
@property (nonatomic, strong) UIButton *addImageButton;
@property (nonatomic, strong) UIView *editToolView;

@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) YYTextView *postTextView;
@property (nonatomic, strong) UIImage *postImage;
@property (nonatomic, strong) NSString *postImageKey;
@property (nonatomic, strong) UIButton *deleteImageButton;
@property (nonatomic, strong) UIButton *publishPostButton;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation PostPublishViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发表";
    
    [self addNavigationBar];
    [self addContainerView];
    [self addEditZone];
    [self initAMap];
    
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

#pragma mark - Private Methods

- (void)addNavigationBar
{
    [super addNavigationBar];
    
    UIImage *publishImage = [UIImage imageNamed:@"icon_nav_publish"];
    self.publishPostButton = [UIButton rightBarButtonWithImage:publishImage highlightedImage:publishImage target:self action:@selector(handlePublishPostButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:self.publishPostButton];
}

- (void)addContainerView
{
    self.containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    self.containerView.delegate = self;
    self.containerView.backgroundColor = Color_White;
    
    [self.view addSubview:self.containerView];
    [self.view sendSubviewToBack:self.containerView];
}

- (void)addEditZone
{
    
    SKTopicParser *topicParser = [SKTopicParser new];
    self.postTextView = [[YYTextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, self.containerView.height - 10)];
//    @"#[^#]+?#"
    self.postTextView.textParser = topicParser;
    self.postTextView.textColor = Color_Gray2;
    self.postTextView.font = FONT(14);
    self.postTextView.delegate = self;
    self.postTextView.tintColor = Color_Green1;
    if (self.postTitle) {
        self.postTextView.text = [NSString stringWithFormat:@"#%@#", self.postTitle];
    }
    [self.containerView addSubview:self.postTextView];
    
    self.postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    self.postImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.postImageView.hidden = YES;
    self.postImageView.layer.masksToBounds = YES;
    self.postImageView.userInteractionEnabled = YES;
    [self.containerView addSubview:self.postImageView];
    
    self.deleteImageButton = [UIButton buttonWithImage:[UIImage imageNamed:@"icon_pub_delete_image"] highlightedImage:[UIImage imageNamed:@"icon_pub_delete_image"] target:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    self.deleteImageButton.top = 0;
    self.deleteImageButton.right = SCREEN_WIDTH;
    [self.postImageView addSubview:self.deleteImageButton];
    
    self.editToolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.containerView.height - 44, SCREEN_WIDTH, 44)];
    [self.containerView addSubview:self.editToolView];
    
    self.addTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addTitleButton setTitle:@"插入话题" forState:UIControlStateNormal];
    [self.addTitleButton setTitleColor:Color_Green1 forState:UIControlStateNormal];
    [self.addTitleButton setImage:[UIImage imageNamed:@"icon_pub_title"] forState:UIControlStateNormal];
    self.addTitleButton.titleLabel.font = FONT(14);
    self.addTitleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.addTitleButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [self.addTitleButton addTarget:self action:@selector(addTitle) forControlEvents:UIControlEventTouchUpInside];
    [self.addTitleButton sizeToFit];
    self.addTitleButton.height = 44;
    self.addTitleButton.width = self.addTitleButton.width + 12;
    self.addTitleButton.left = 20;
    self.addTitleButton.top = 0;
    
    self.addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addImageButton setTitle:@"插入图片" forState:UIControlStateNormal];
    [self.addImageButton setTitleColor:Color_Green1 forState:UIControlStateNormal];
    [self.addImageButton setImage:[UIImage imageNamed:@"icon_pub_image"] forState:UIControlStateNormal];
    self.addImageButton.titleLabel.font = FONT(14);
    self.addImageButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.addImageButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [self.addImageButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [self.addImageButton sizeToFit];
    self.addImageButton.height = 44;
    self.addImageButton.width = self.addImageButton.width + 12;
    self.addImageButton.left = self.addTitleButton.right + 20;
    self.addImageButton.top = 0;
    
    [self.editToolView addSubview:self.addTitleButton];
    [self.editToolView addSubview:self.addImageButton];
    
}

- (void)initAMap
{
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    // 定位超时时间，可修改，最小2s
    self.locationManager.locationTimeout = 3;
    // 逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 3;
}

- (void)imageFromSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = sourceType;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)showImage
{
    self.postImageView.image = self.postImage;
    self.postImageView.hidden = NO;
    
    self.postTextView.top = self.postImageView.bottom + 10;
    self.postTextView.height = self.containerView.height - self.postImageView.bottom - 10;
}

- (void)hideImage
{
    self.postImageView.image = nil;
    self.postImageView.hidden = YES;
    
    self.postImageKey = nil;
    
    self.postTextView.top = 10;
    self.postTextView.height = self.containerView.height - 10;
}

- (void)publishPost
{
    weakify(self);
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        strongify(self);
        
        if (error)
        {
            // TODO: 错误消息待优化
            [self showAlert:@"定位失败！"];
            DBG(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            self.publishPostButton.enabled = YES;
            
            return;
            
        }
        
        DBG(@"location:%@", location);
        
        if (regeocode)
        {
            DBG(@"reGeocode:%@", regeocode);
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setSafeObject:@(location.coordinate.longitude) forKey:@"longitude"];
        [params setSafeObject:@(location.coordinate.latitude) forKey:@"latitude"];
        [params setSafeObject:regeocode.country forKey:@"country"];
        [params setSafeObject:regeocode.province forKey:@"province"];
        [params setSafeObject:regeocode.city forKey:@"city"];
        [params setSafeObject:regeocode.street forKey:@"street"];
        [params setSafeObject:regeocode.AOIName forKey:@"aoi"];
        [params setSafeObject:[TTUserService sharedService].id forKey:@"userId"];
        [params setSafeObject:self.postTextView.text forKey:@"content"];
        [params setSafeObject:self.postImageKey forKey:@"imageUrl"];
        
        [PostRequest publishPostWithParams:params success:^(PostPublishResultModel *resultModel) {
            
            [self showNotice:@"发布成功"];
            
            self.publishPostButton.enabled = YES;
            
            NSDictionary *userInfo = @{@"post" : resultModel.post};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_APP_POST_PUBLISH_SUCCESS object:nil userInfo:userInfo];
            
            [self clickback];
            
        } failure:^(StatusModel *status) {
            
            DBG(@"%@", status);
            
            self.publishPostButton.enabled = YES;
            
            [self showNotice:status.msg];
            
        }];
        
    }];
    
}

#pragma mark - Event Response

- (void)addTitle
{
    [self.view endEditing:YES];
    
    TitleAddViewController *vc = [[TitleAddViewController alloc] init];
    weakify(self);
    vc.callback = ^(NSString *title) {
        DBG(@"title:%@", title);
        strongify(self);
        self.postTextView.text = [NSString stringWithFormat:@"#%@# %@", title, self.postTextView.text];
    };
    
    TTNavigationController *navigationController = [[ApplicationEntrance shareEntrance] currentNavigationController];
    [navigationController pushViewController:vc animated:YES];
}

- (void)addImage
{
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选取", nil];
    [actionSheet showInView:self.view];
}

- (void)deleteImage
{
    self.postImage = nil;
    [self hideImage];
}

- (void)handlePublishPostButton
{
    DBG(@"publishPost");
    
    [self.view endEditing:YES];
    
    self.publishPostButton.enabled = NO;
    
    // TODO: 添加Loading，遮盖整个界面
    
    if ( self.postImage ) {
        
        weakify(self);
        
        [PostRequest getQiniuTokenWithSuccess:^(NSString *token) {
            
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            NSData *imageData = UIImageJPEGRepresentation(self.postImage, 1);
            [upManager putData:imageData key:nil token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          
                          strongify(self);
                          
                          self.postImageKey = [resp objectForKey:@"key"];
                          
                          [self publishPost];
                          //                      DBG(@"%@", info);
                          //                      DBG(@"%@", resp);
                          //                      DBG(@"%@", key);
                      } option:nil];
            
        } failure:^(StatusModel *status) {
            
            DBG(@"%@", status);
            
            strongify(self);
            
            self.publishPostButton.enabled = YES;
            
            [self showNotice:status.msg];
            
        }];
    } else {
        [self publishPost];
    }
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // 拍照
            [self imageFromSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
            
        case 1: // 从手机相册选取
            [self imageFromSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]){
        
        self.postImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [self showImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification Methods

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
        self.editToolView.bottom = self.containerView.height - keyboardHeight;
    }];
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notification {
    
    weakify(self);
    [UIView animateWithDuration:0.2f animations:^{
        strongify(self);
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        self.editToolView.bottom = self.containerView.height;
    }];
}



@end
