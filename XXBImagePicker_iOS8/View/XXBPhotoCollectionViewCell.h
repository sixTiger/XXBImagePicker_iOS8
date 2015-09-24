//
//  XXBPhotoCollectionViewCell.h
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/9/24.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;
@class XXBPhotoModel;
@interface XXBPhotoCollectionViewCell : UICollectionViewCell
@property(nonatomic , strong)XXBPhotoModel *photoModel;
@end
