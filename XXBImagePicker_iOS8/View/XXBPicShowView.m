//
//  XXBPicShowView.m
//  Pix72
//
//  Created by 杨小兵 on 15/5/24.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBPicShowView.h"
@interface UIImage (PHelp)

- (CGSize)sizeThatFits:(CGSize)size;

@end

@implementation UIImage (PHelp)

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize imageSize = CGSizeMake(self.size.width / self.scale,
                                  self.size.height / self.scale);
    
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

@end

@interface UIImageView (PHelp)

- (CGSize)contentSize;

@end

@implementation UIImageView (PHelp)

- (CGSize)contentSize
{
    return [self.image sizeThatFits:self.bounds.size];
}

@end

@interface XXBPicShowView ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIImageView    *imageView;
@property (nonatomic , assign)BOOL          rotating;
@property (nonatomic , assign)CGSize        minSize;
@property (nonatomic , assign)BOOL          singleTap;
@end
@implementation XXBPicShowView

- (void)setImage:(UIImage *)image
{
    if (image == _image) {
        return;
    }
    [self setZoomScale:self.minimumZoomScale animated:YES];
    _image = image;
    self.imageView.image = _image;
    self.imageView.frame = self.bounds;
    
    CGSize imageSize;
    if (_image)
    {
        imageSize = self.imageView.contentSize;
    }
    else
    {
        imageSize = [UIScreen mainScreen].bounds.size;
    }
    self.imageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.imageView.center = CGPointMake(imageSize.width / 2, imageSize.height / 2);
    self.contentSize = imageSize;
    self.minSize = imageSize;
    [self setMaxMinZoomScale];
    [self centerContent];
    [self setupGestureRecognizer];
    [self setupRotationNotification];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.delegate = self;
        self.bouncesZoom = YES;
        self.singleTap = YES;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.rotating)
    {
        self.rotating = NO;
        CGSize containerSize = self.imageView.frame.size;
        BOOL containerSmallerThanSelf = (containerSize.width < CGRectGetWidth(self.bounds)) && (containerSize.height < CGRectGetHeight(self.bounds));
        
        CGSize imageSize = [self.imageView.image sizeThatFits:self.bounds.size];
        CGFloat minZoomScale = imageSize.width / self.minSize.width;
        self.minimumZoomScale = minZoomScale;
        if (containerSmallerThanSelf || self.zoomScale == self.minimumZoomScale)
        { // 宽度或高度 都小于 self 的宽度和高度
            self.zoomScale = minZoomScale;
        }
        [self centerContent];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView =  imageView;
        [self addSubview: imageView];
    }
    return _imageView;
}
#pragma mark - Setup

- (void)setupRotationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}
- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandler:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandler:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:singleTapGestureRecognizer];
}
#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContent];
}
#pragma mark - 手势处理
- (void)singleTapHandler:(UITapGestureRecognizer *)recognizer
{
    [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.5];
}
- (void)singleTapAction
{
    if (!self.singleTap)
    {
        self.singleTap = YES;
        return;
    }
    if ([self.picShowViewdelegate respondsToSelector:@selector(picShowViewSingletap:)])
    {
        [self.picShowViewdelegate picShowViewSingletap:self];
    }
}
//手势
- (void)doubleTapHandler:(UITapGestureRecognizer *)recognizer
{
    self.singleTap = NO;
    if (self.zoomScale > self.minimumZoomScale)
    {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else
    {
        if (self.zoomScale < self.maximumZoomScale)
        {
            CGPoint location = [recognizer locationInView:recognizer.view];
            CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
            zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2);
            [self zoomToRect:zoomToRect animated:YES];
        }
    }
    
}
#pragma mark - Notification

- (void)orientationChanged:(NSNotification *)notification
{
    self.rotating = YES;
}
#pragma mark - Helper

- (void)setMaxMinZoomScale
{
    CGSize imageSize = self.imageView.image.size;
    CGSize imagePresentationSize = self.imageView.contentSize;
    CGFloat maxScale = MAX(imageSize.height / imagePresentationSize.height, imageSize.width / imagePresentationSize.width);
    self.maximumZoomScale = MAX(1, maxScale);
    self.minimumZoomScale = 1.0;
}
- (void)centerContent
{
    CGRect frame = self.imageView.frame;
    if (self.imageView.bounds.size.width <= 0)
    {
        [self setImage:nil];
        frame = self.imageView.frame;
    }
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width)
    {
        left = (self.bounds.size.width - self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height)
    {
        top = (self.bounds.size.height - self.contentSize.height) * 0.5f;
    }
    top -= frame.origin.y;
    left -= frame.origin.x;
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}


@end
