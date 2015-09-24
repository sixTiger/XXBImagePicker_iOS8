//
//  XXBPhotoModel.h
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/9/24.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface XXBPhotoModel : NSObject
/**
 *  小图片
 */
@property(nonatomic , strong)UIImage        *image;
/**
 *  图片资源
 */
@property(nonatomic , strong)PHAsset        *asset;
/**
 *  当前modle的indexPath
 */
@property(nonatomic , strong)NSIndexPath    *indexPath;

/**
 *  标记这张照片是否选中了
 */
@property(nonatomic , assign)BOOL           select ;
/**
 *  当前的第几个
 */
@property(nonatomic , assign)NSInteger      index;
/**
 *  是否显示数字角标
 */
@property(nonatomic , assign)BOOL           showPage;
/**
 *  对顶的标示
 */
@property(nonatomic , assign)NSInteger      tag;
@end
