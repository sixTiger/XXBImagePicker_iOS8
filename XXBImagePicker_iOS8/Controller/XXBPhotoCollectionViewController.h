//
//  XXBPhotoCollectionViewController.h
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "XXBPhotoGroupModel.h"
@class XXBPhotoCollectionViewController;
@protocol XXBPhotoCollectionViewControllerDelegate <NSObject>
@optional
/**
 *  选择完照片的回调
 *
 *  @param photoCollectionViewController 回调的 XXBPhotoCollectionViewController
 *  @param selectPhotos   选择的照片的相关资源
 */
- (void)photoCollectionViewController:(XXBPhotoCollectionViewController *)photoCollectionViewController didselectPhotos:(NSArray *)selectPhotos;
/**
 *  选择完照片的回调
 *
 *  @param photoCollectionViewController 回调的 XXBPhotoCollectionViewController
 */
- (void)photoCollectionViewControllerCancleSelected:(XXBPhotoCollectionViewController *)photoCollectionViewController;
@end
@interface XXBPhotoCollectionViewController : UICollectionViewController
/**
 *  所有的照片的模型
 */
@property(nonatomic , strong)XXBPhotoGroupModel                         *photoGroupModel;
/**
 *  选中的相册的XXBPhotoModel
 */
@property(nonatomic , strong)NSMutableArray                             *selectPhotoModels;
/**
 *  代理
 */
@property(nonatomic , weak)id<XXBPhotoCollectionViewControllerDelegate> delegate;


- (void)scrollToBottom;
@end
