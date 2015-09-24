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
@property(nonatomic , strong)UIImage    *image;
/**
 *  图片资源
 */
@property(nonatomic , strong)PHAsset    *asset;
@property(nonatomic , assign)NSInteger  tag;
@end
