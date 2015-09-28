//
//  XXBImagePickerController.h
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    /**
     *  选择的顺序
     */
    XXBPhotoSortTypeSelectOrder = 0,
    /**
     *  选择的顺序 倒叙
     */
    XXBPhotoSortTypeSelectDesc = 1,
    /**
     *  系统的顺序
     */
    XXBPhotoSortTypeSystemOrder = 2,
    /**
     *  系统的顺序 倒叙
     */
    XXBPhotoSortTypeSystemDesc = 3,
} XXBPhotoSortType;

@class XXBImagePicker;

@protocol XXBImagePickerDelegate <NSObject>
/**
 *  从相册里边选择完照片的回调
 *
 *  @param imagePickController 回调的 imagePickController
 *  @param selectPhotos        选择的照片的资源路径等相关信息
 */
- (void)imagePickerController:(XXBImagePicker *)imagePickController didselectPhotos:(NSArray *)selectPhotos;
@optional
/**
 *  从相册里边选择完照片的回调
 *
 *  @param imagePickController 回调的imagePickController
 */
- (void)imagePickerControllerCancleselect:(XXBImagePicker *)imagePickController;
@end

@interface XXBImagePicker : UINavigationController

/**
 *  竖屏状态下默认照片个数
 *  默认是4个
 */
@property(nonatomic , assign)NSInteger photoInRow;
/**
 *  如果想在打开的时候原来选中的图片还是选中的话需要设置 selectPhotoALAssets
 *
 *  里边放的是 XXBPhotoModle 模型
 *
 *  原来选中的photo的相关信息 默认为空
 */
@property(nonatomic , strong)NSMutableArray *selectPhotoModels;
/**
 *  是否显示数字标签
 */
@property(nonatomic , assign)BOOL showPage;
/**
 *  是否默认显示所有的相册
 */
@property(nonatomic , assign)BOOL showAllPhoto;
/**
 *  最多可选的照片的张数
 */
@property(nonatomic , assign)NSInteger photoCount;
/**
 *  用来处理选中和和取消的代理方法
 */
@property(nonatomic , weak)id<XXBImagePickerDelegate> imagePickerDelegate;
@property(nonatomic , assign)XXBPhotoSortType photoSortType;
@end
