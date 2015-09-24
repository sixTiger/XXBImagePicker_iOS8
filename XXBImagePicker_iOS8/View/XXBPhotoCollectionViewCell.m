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
    [self p_updateImage];
}
/**
 *  更新照片
 */
- (void)p_updateImage
{
    if (self.photoModel.image)
    {
        self.imageView.image = self.photoModel.image;
        return;
    }
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat itemWidth = self.contentView.bounds.size.width * scale;
    CGFloat itemHeight = self.contentView.bounds.size.height *scale;
    CGSize AssetGridThumbnailSize = CGSizeMake(itemWidth , itemHeight);
    [[PHImageManager defaultManager] requestImageForAsset:self.photoModel.asset
                                               targetSize:AssetGridThumbnailSize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:nil
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                self.imageView.image = result;
                                                if (self.tag == self.photoModel.tag)
                                                {
                                                    self.photoModel.image  = result;
                                                }
                                            }];
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
