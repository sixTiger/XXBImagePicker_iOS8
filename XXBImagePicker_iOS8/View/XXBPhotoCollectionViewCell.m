//
//  XXBPhotoCollectionViewCell.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/9/24.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import "XXBPhotoCollectionViewCell.h"
#import "XXBPhotoModel.h"

@interface XXBPhotoCollectionViewCell ()
@property(nonatomic , weak)UIImageView *imageView;
@end

@implementation XXBPhotoCollectionViewCell
- (void)setPhotoModel:(XXBPhotoModel *)photoModel
{
    
    _photoModel = photoModel;
    _photoModel.tag = self.tag;
    [self p_updateImageAsync];
}
- (void)p_updateImageAsync
{
    self.imageView.image = nil;
    if (self.photoModel.image)
    {
        self.imageView.image = self.photoModel.image;
        return;
    }
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat itemWidth = self.contentView.bounds.size.width * scale;
        CGFloat itemHeight = self.contentView.bounds.size.height *scale;
        CGSize AssetGridThumbnailSize = CGSizeMake(itemWidth , itemHeight);
        XXBPhotoModel *photoModel = self.photoModel;
        __weak typeof(self) weakSelf = self;
        [[PHImageManager defaultManager] requestImageForAsset:self.photoModel.asset
                                                   targetSize:AssetGridThumbnailSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:nil
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    if (!weakSelf )
                                                    {
                                                        return ;
                                                    }
                                                    photoModel.image  = result;
                                                    if(photoModel.tag == weakSelf.photoModel.tag)
                                                    {
                                                        
                                                        weakSelf.imageView.image = result;
                                                        
                                                    }
                                                }];
        
    });
    
}
/**
 *  更新照片
 */
- (void)p_updateImageSync
{
    self.imageView.image = nil;
    if (self.photoModel.image)
    {
        self.imageView.image = self.photoModel.image;
        return;
    }
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat itemWidth = self.contentView.bounds.size.width * scale;
        CGFloat itemHeight = self.contentView.bounds.size.height *scale;
        CGSize AssetGridThumbnailSize = CGSizeMake(itemWidth , itemHeight);
        XXBPhotoModel *photoModel = self.photoModel;
        
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        //        option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        option.synchronous = YES;
        __weak typeof(self) weakSelf = self;
        [[PHImageManager defaultManager] requestImageForAsset:self.photoModel.asset
                                                   targetSize:AssetGridThumbnailSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:option
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    if (!weakSelf )
                                                    {
                                                        return ;
                                                    }
                                                    photoModel.image  = result;
                                                    if(weakSelf.tag == weakSelf.photoModel.tag)
                                                    {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            weakSelf.imageView.image = result;
                                                        });
                                                    }
                                                }];
        
    });
}
- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}
@end
