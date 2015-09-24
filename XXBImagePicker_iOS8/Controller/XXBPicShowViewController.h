//
//  XXBPicShowViewController.h
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/9/23.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface XXBPicShowViewController : UIViewController
/**
 *  相册组
 */
@property (nonatomic, strong) PHFetchResult         *assetsFetchResults;
/**
 *  相册组
 */
@property (nonatomic, strong) PHAssetCollection     *assetCollection;
/**
 *  当前下标
 */
@property(nonatomic , assign) NSInteger             index;
@end
