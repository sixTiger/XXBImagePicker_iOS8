//
//  XXBPhotoCollectionViewCell.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/9/24.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import "XXBPhotoCollectionViewCell.h"
#import "XXBPhotoModel.h"
#import "XXBBadgeValueBtn.h"

@interface XXBPhotoCollectionViewCell ()
@property(nonatomic , weak)UIImageView          *imageView;
@property(nonatomic , weak)XXBBadgeValueBtn     *badgeValueButton;
@property(nonatomic , weak)UIButton             *selectButton;
/**
 *  选中的时候的蒙版
 */
@property(nonatomic , weak)UIImageView          *selectCover;

@end

@implementation XXBPhotoCollectionViewCell
- (void)setPhotoModel:(XXBPhotoModel *)photoModel
{
    
    _photoModel = photoModel;
    _photoModel.tag = self.tag;
    self.badgeValueButton.badgeValue = _photoModel.index;
    self.selectButton.selected = _photoModel.select ;
    self.selectCover.hidden = !_photoModel.select;
    [self p_updateImageAsync];
}
/**
 * 异步的方法更新image
 */
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
 *  同步 更新照片
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
        option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
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
- (UIImageView *)selectCover
{
    if (_selectCover == nil)
    {
        UIImageView *selectCover = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.imageView addSubview:selectCover];
        selectCover.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        _selectCover = selectCover;
    }
    return _selectCover;
}
- (XXBBadgeValueBtn *)badgeValueButton
{
    if (_badgeValueButton == nil)
    {
        XXBBadgeValueBtn *badgeValueButton = [[XXBBadgeValueBtn alloc] initWithFrame:CGRectMake(2, 2, 10, 10)];
        [self.selectCover addSubview:badgeValueButton];
        _badgeValueButton = badgeValueButton;
        
    }
    return _badgeValueButton;
}
- (UIButton *)selectButton
{
    if (_selectButton == nil)
    {
        //右上角的小图标的尺寸
        CGFloat width = 30;
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 0, 0);
        selectButton.frame = CGRectMake(self.bounds.size.width - width, self.bounds.size.width - width , width , width);
        [self.contentView insertSubview:selectButton aboveSubview:self.contentView];
        [selectButton setImage:[UIImage imageNamed:@"XXBImagePicker.bundle/XXBPhoto"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"XXBImagePicker.bundle/XXBPhotoSelected"] forState:UIControlStateSelected];
        [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton =selectButton;
    }
    return _selectButton;
}
- (void)selectButtonClick:(UIButton *)selectButton
{
    selectButton.selected = !selectButton.selected;
    self.photoModel.select = !self.photoModel.select;
    [self.delegate photoCollectionViewCellSelectButtonDidclick:self];
}
@end
