//
//  XXBPicShowCollectionViewCell.h
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/9/24.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;
@class XXBPicShowCollectionViewCell;
@protocol XXBPicShowCollectionViewCellDelegate <NSObject>
- (void)picShowCollectionViewCellSingletap:(XXBPicShowCollectionViewCell *)picShowCollectionViewCell;
@end
@interface XXBPicShowCollectionViewCell : UICollectionViewCell
@property(nonatomic , weak)id<XXBPicShowCollectionViewCellDelegate> delegate;
@property(nonatomic , strong)PHAsset *asset;
@end
