//
//  XXBPhotoCollectionViewController.h
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@interface XXBPhotoCollectionViewController : UICollectionViewController
/**
 *  照片组的先关信息
 */
@property (nonatomic, strong) PHFetchResult         *assetsFetchResults;
/**
 *  所有的照片的模型
 */
@property(nonatomic , strong) NSArray               *photoModleArray;
/**
 *  选中的相册的XXBPhotoModel
 */
@property(nonatomic , strong)NSMutableArray         *selectPhotoModels;
@end
