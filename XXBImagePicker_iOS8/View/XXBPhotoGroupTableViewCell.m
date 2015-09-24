//
//  XXBImagePickerTableViewCell.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "XXBPhotoGroupTableViewCell.h"

@interface XXBPhotoGroupTableViewCell ()

@property(nonatomic , weak)UIImageView *iconImageView;
@property(nonatomic , weak)UILabel *titleLabel;
@property(nonatomic , weak)UILabel *subTitleLabel;
@end

@implementation XXBPhotoGroupTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat padding = 2;
    self.iconImageView.frame = CGRectMake(padding, padding,CGRectGetHeight(self.frame) - padding, CGRectGetHeight(self.frame) - padding);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + padding, padding, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.iconImageView.frame) - padding, CGRectGetHeight(self.frame) * 0.5);
    
    self.subTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + padding, CGRectGetHeight(self.frame) * 0.5, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.iconImageView.frame) - padding, CGRectGetHeight(self.frame) * 0.5);
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.titleLabel.text = _title;
}
- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = [subTitle copy];
    self.subTitleLabel.text = _subTitle;
}
- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    self.iconImageView.image = _iconImage;
}




- (void)setAssetCollection:(PHAssetCollection *)assetCollection
{
    _assetCollection = assetCollection;
    self.titleLabel.text = assetCollection.localizedTitle;
    PHFetchResult *countResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    self.subTitleLabel.text = [NSString stringWithFormat:@"%@",@(countResult.count)];
    PHAsset *asset = [countResult lastObject];
    CGSize AssetGridThumbnailSize = CGSizeMake(80, 80);
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:AssetGridThumbnailSize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:nil
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                self.iconImageView.image = result;
                                                
                                            }];
    
}
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [self.contentView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _iconImageView = imageView;
    }
    return _iconImageView;
}
- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(65, 0,60,40)];
        [self.contentView addSubview:label];
        _titleLabel = label;
        
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel
{
    if (_subTitleLabel == nil)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(65, 0,60,40)];
        [self.contentView addSubview:label];
        _subTitleLabel = label;
    }
    return _subTitleLabel;
}
@end
