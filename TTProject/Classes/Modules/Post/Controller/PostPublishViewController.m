//
//  PostPublishViewController.m
//  TTProject
//
//  Created by Ivan on 16/4/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "PostPublishViewController.h"
#import "TTHighlightTextView.h"
#import "PostRequest.h"
#import <QiniuSDK.h>
#import <YYText/YYText.h>
#import "SKTopicParser.h"

@interface PostPublishViewController () <UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YYTextViewDelegate>

@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) UIButton *addTitleButton;
@property (nonatomic, strong) UIButton *addImageButton;

@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) YYTextView *postTextView;
@property (nonatomic, strong) UIImage *postImage;
@property (nonatomic, strong) NSString *postImageKey;
@property (nonatomic, strong) UIButton *deleteImageButton;

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
}

#pragma mark - Private Methods

- (void)addNavigationBar
{
    [super addNavigationBar];
    
    UIImage *publishImage = [UIImage imageNamed:@"icon_nav_publish"];
    UIButton *publishPostButton = [UIButton rightBarButtonWithImage:publishImage highlightedImage:publishImage target:self action:@selector(addPost) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightBarButton:publishPostButton];
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
    self.addTitleButton = [UIButton buttonWithImage:[UIImage imageNamed:@"icon_pub_title"] target:self action:@selector(addTitle) forControlEvents:UIControlEventTouchUpInside];
    self.addTitleButton.top = 10;
    self.addTitleButton.left = 10;
    
    self.addImageButton = [UIButton buttonWithImage:[UIImage imageNamed:@"icon_pub_image"] target:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    self.addImageButton.top = 10;
    self.addImageButton.left = self.addTitleButton.right + 10;
    [self.containerView addSubview:self.addTitleButton];
    [self.containerView addSubview:self.addImageButton];
    
    TTTopicParser *topicParser = [TTTopicParser new];
    
    self.postTextView = [[YYTextView alloc] initWithFrame:CGRectMake(10, self.addTitleButton.bottom + 10, SCREEN_WIDTH - 20, self.containerView.height - self.addTitleButton.bottom - 10)];
//    @"#[^#]+?#"
    self.postTextView.textParser = topicParser;
    self.postTextView.textColor = Color_Gray2;
    self.postTextView.font = FONT(14);
    self.postTextView.delegate = self;
    self.postTextView.tintColor = Color_Green1;
    [self.containerView addSubview:self.postTextView];
    
    self.postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.addTitleButton.bottom + 10, SCREEN_WIDTH, 100)];
    self.postImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.postImageView.hidden = YES;
    self.postImageView.layer.masksToBounds = YES;
    self.postImageView.userInteractionEnabled = YES;
    [self.containerView addSubview:self.postImageView];
    
    self.deleteImageButton = [UIButton buttonWithImage:[UIImage imageNamed:@"icon_pub_delete_image"] highlightedImage:[UIImage imageNamed:@"icon_pub_delete_image"] target:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    self.deleteImageButton.top = 0;
    self.deleteImageButton.right = SCREEN_WIDTH;
    [self.postImageView addSubview:self.deleteImageButton];
    
}

- (void)avatarFromSourceType:(UIImagePickerControllerSourceType)sourceType
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
    
    self.postTextView.top = self.addTitleButton.bottom + 10;
    self.postTextView.height = self.containerView.height - self.addTitleButton.bottom - 10;
}

- (void)publishPost
{
    //TODO: 参数待实装
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:@"120.121806" forKey:@"longitude"];
    [params setSafeObject:@"30.274818" forKey:@"latitude"];
    [params setSafeObject:@"中国" forKey:@"country"];
    [params setSafeObject:@"浙江" forKey:@"province"];
    [params setSafeObject:@"杭州" forKey:@"city"];
    [params setSafeObject:@"通向天国的阶梯" forKey:@"street"];
    [params setSafeObject:@"天上人间" forKey:@"aoi"];
    [params setSafeObject:[TTUserService sharedService].id forKey:@"userId"];
//    title
    [params setSafeObject:self.postTextView.text forKey:@"content"];
    [params setSafeObject:self.postImageKey forKey:@"imageUrl"];
    
    weakify(self);

    [PostRequest publishPostWithParams:params success:^(PostPublishResultModel *resultModel) {

        strongify(self);

        [self showNotice:@"发布成功"];

    } failure:^(StatusModel *status) {

        DBG(@"%@", status);

        strongify(self);
        
        [self showNotice:status.msg];
        
    }];
}

#pragma mark - Event Response

- (void)addTitle
{
    
}

- (void)addImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选取", nil];
    [actionSheet showInView:self.view];
}

- (void)deleteImage
{
    self.postImage = nil;
    [self hideImage];
}

- (void)addPost
{
    DBG(@"publishPost");
    
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
            [self avatarFromSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
            
        case 1: // 从手机相册选取
            [self avatarFromSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
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

#pragma mark - YYTextViewDelegate



@end
