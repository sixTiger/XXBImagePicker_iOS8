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
@property (strong) PHFetchResult *assetsFetchResults;
@property (strong) PHAssetCollection *assetCollection;
@end