//
//  TTGalleryView.m
//  TTProject
//
//  Created by Ivan on 16/4/21.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "TTGalleryView.h"

@interface TTGalleryView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation TTGalleryView

#pragma mark - Override Methods

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self ) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
    }
    
    return self;
}

#pragma mark - Custom Methods

- (void)showImageWithSrc:(NSString *)imageSrc
{
    weakify(self);
    [self.imageView setOnlineImage:imageSrc complete:^(UIImage *image) {
        strongify(self);
        
        CGFloat screenAspectRatio = SCREEN_WIDTH / SCREEN_HEIGHT;
        CGFloat imageAspectRatio = image.size.width / image.size.height;
        CGFloat width = SCREEN_WIDTH;
        CGFloat height = SCREEN_HEIGHT;
        
        if ( imageAspectRatio < screenAspectRatio ) {
            
            width = imageAspectRatio * SCREEN_HEIGHT;
            
        } else if ( imageAspectRatio > screenAspectRatio ) {
            
            height = SCREEN_WIDTH / imageAspectRatio;
            
        }
        
        [self.scrollView setZoomScale:1 animated:NO];
        
        self.imageView.width = width;
        self.imageView.height = height;
        
        [self putImageViewToCenter];
        
    }];
    
}

#pragma mark - Getters And Setters

- (UIImageView *)imageView
{
    if( !_imageView ){
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
    }
    
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if( !_scrollView ){
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 3.0f;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self putImageViewToCenter];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
//{
//    
//}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self.scrollView setZoomScale:scale animated:NO];
}

#pragma mark - Private Methods

- (void) putImageViewToCenter
{
    CGFloat centerX = self.scrollView.center.x;
    CGFloat centerY = self.scrollView.center.y;
    
    centerX = self.scrollView.contentSize.width > self.scrollView.width ? self.scrollView.contentSize.width / 2 : centerX;
    
    centerY = self.scrollView.contentSize.height > self.scrollView.height ? self.scrollView.contentSize.height / 2 : centerY;
    
    [self.imageView setCenter:CGPointMake(centerX, centerY)];
}

@end
