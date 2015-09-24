//
//  XXBImagePickerTableViewCell.h
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@interface XXBPhotoGroupTableViewCell : UITableViewCell
@property(nonatomic , strong)UIImage *iconImage;
@property(nonatomic , copy)NSString *title;
@property(nonatomic , copy)NSString *subTitle;
/**
 *  照片组的相关信息
 */
@property(nonatomic , strong)PHAssetCollection *assetCollection;
@end
