//
//  XXBPhotoGroupModel.h
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/9/28.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface XXBPhotoGroupModel : NSObject
@property(nonatomic , assign)NSInteger  tag;
/**
 *  图片相关资源的数组
 */
@property(nonatomic , strong)NSArray            *photoModelArray;
/**
 *  图片分组的相关信息
 */
@property(nonatomic , strong)PHAssetCollection  *assetCollection;
@end
