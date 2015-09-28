//
//  XXBPhotoGroupViewController.h
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXBPhotoGroupViewController;
@protocol XXBPhotoGroupViewControllerDelegate <NSObject>
@optional
/**
 *  选择完照片的回调
 *
 *  @param photoGroupView 回调的 photoGroupView
 *  @param selectPhotos   选择的照片
 */
- (void)photoGroupViewController:(XXBPhotoGroupViewController *)photoGroupView didselectPhotos:(NSArray *)selectPhotos;
/**
 *  选择完照片的回调
 *
 *  @param photoGroupView 回调的 photoGroupView
 */
- (void)photoGroupViewControllerCancleSelected:(XXBPhotoGroupViewController *)photoGroupView;
@end
@interface XXBPhotoGroupViewController : UITableViewController
/**
 *  一行显示的照片个数
 *  默认是4个
 */
@property(nonatomic , assign)NSInteger                              photoInRow;
/**
 *  选中的相册的XXBPhotoModel
 */
@property(nonatomic , strong)NSMutableArray                         *selectPhotoModels;
/**
 *  是否显示数字标签
 */
@property(nonatomic , assign)BOOL                                   showPage;
/**
 *  最多可选的照片的张数
 */
@property(nonatomic , assign)NSInteger                              photoCount;
/**
 *  是否显示所有的照片
 */
@property(nonatomic , assign)BOOL                                   showAllPhoto;
@property(nonatomic , weak)id<XXBPhotoGroupViewControllerDelegate>  delegate;
@end
