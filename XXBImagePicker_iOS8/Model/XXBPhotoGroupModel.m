//
//  XXBPhotoGroupModel.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/9/28.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import "XXBPhotoGroupModel.h"
#import "XXBPhotoModel.h"
@implementation XXBPhotoGroupModel
- (void)setAssetCollection:(PHAssetCollection *)assetCollection
{
    _assetCollection = assetCollection;
    PHFetchResult *countResult = [PHAsset fetchAssetsInAssetCollection:_assetCollection options:nil];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i< countResult.count; i++)
    {
        XXBPhotoModel *photoModel = [[XXBPhotoModel alloc] init];
        photoModel.asset = countResult[i];
        [array addObject:photoModel];
    }
    self.photoModelArray = [array copy];
}
@end
