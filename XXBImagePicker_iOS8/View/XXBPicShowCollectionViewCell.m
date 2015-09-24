//
//  XXBPicShowCollectionViewCell.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/9/24.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import "XXBPicShowCollectionViewCell.h"
#import "XXBPicShowView.h"
@interface XXBPicShowCollectionViewCell ()<XXBPicShowViewDelegate>
@property(nonatomic , weak)XXBPicShowView *picShowView;
@end
@implementation XXBPicShowCollectionViewCell
- (void)setAsset:(PHAsset *)asset
{
    _asset = asset;
    [self p_updateImage];
}
- (void)p_updateImage
{
    [self p_showRealPhoto];
}
/**
 *  显示2X图
 */
- (void)p_show2XPhoto
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(self.picShowView.bounds) * scale, CGRectGetHeight(self.picShowView.bounds) * scale);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // Download from cloud if necessary
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self.progressView.progress = progress;
            //            self.progressView.hidden = (progress <= 0.0 || progress >= 1.0);
        });
    };
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            self.picShowView.image = result;
        }
    }];
}
/**
 *  按照原始大小显示
 */
- (void)p_showRealPhoto
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // Download from cloud if necessary
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //   如果没有图片的话去网络拉去图片
            //   self.progressView.progress = progress;
            //   self.progressView.hidden = (progress <= 0.0 || progress >= 1.0);
        });
    };
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        self.picShowView.image = [UIImage imageWithData:imageData];
    }];
}
- (XXBPicShowView *)picShowView
{
    if (_picShowView == nil)
    {
        XXBPicShowView *picShowView= [[XXBPicShowView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:picShowView];
        picShowView.picShowViewdelegate = self;
        _picShowView = picShowView;
    }
    return _picShowView;
}
#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        PHObjectChangeDetails *changeDetails = [changeInstance changeDetailsForObject:self.asset];
        if (changeDetails)
        {
            self.asset = [changeDetails objectAfterChanges];
            if ([changeDetails assetContentChanged])
            {
                [self p_updateImage];
            }
        }
        
    });
}
- (void)picShowViewSingletap:(XXBPicShowView *)picShowView
{
    if ([self.delegate respondsToSelector:@selector(picShowCollectionViewCellSingletap:)])
    {
        [self.delegate picShowCollectionViewCellSingletap:self];
    }
}
@end
