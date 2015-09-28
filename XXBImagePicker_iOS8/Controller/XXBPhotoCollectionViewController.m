//
//  XXBPhotoCollectionViewController.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "XXBPhotoCollectionViewController.h"
#import <UIKit/UIKit.h>
#import "XXBPicShowViewController.h"
#import "XXBPhotoCollectionViewCell.h"
#import "XXBPhotoModel.h"
#import "XXBImagePickerTabr.h"
#import "XXBPhotoCollectionFootView.h"
@implementation NSIndexSet (Convenience)
- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section
{
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}
@end



@interface XXBPhotoCollectionViewController ()<PHPhotoLibraryChangeObserver,XXBPhotoCollectionViewCellDelegate,XXBImagePickerTabrDelegate>
@property (strong) PHCachingImageManager        *imageManager;

@property(nonatomic , weak)XXBImagePickerTabr   *imagePickerTar;
@property CGRect previousPreheatRect;
@end

@implementation XXBPhotoCollectionViewController

static NSString * const photoCollectionViewCell = @"XXBPhotoCollectionViewCell";
static NSString * const reuseFooterIdentifier = @"XXBPhotoCollectionFootView";
static CGSize AssetGridThumbnailSize;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        [self p_setupCollectionView];
    }
    return self;
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}
- (void)p_setupCollectionView
{
    [self p_setupImagePickerTar];
    self.imageManager = [[PHCachingImageManager alloc] init];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    [self.collectionView registerClass:[XXBPhotoCollectionViewCell class] forCellWithReuseIdentifier:photoCollectionViewCell];
    [self.collectionView registerClass:[XXBPhotoCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier];
    self.collectionView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *collectionViewRight = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *collectionViewLeft = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *collectionViewBottom = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-44];
    NSLayoutConstraint *collectionViewTop = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraints:@[collectionViewLeft, collectionViewRight,collectionViewTop,collectionViewBottom]];

}
- (void)p_setupImagePickerTar
{
    XXBImagePickerTabr *imagePickerTar = [[XXBImagePickerTabr alloc] init];
    [self.view addSubview:imagePickerTar];
    imagePickerTar.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *imagePickerTarRight = [NSLayoutConstraint constraintWithItem:imagePickerTar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *imagePickerTarLeft = [NSLayoutConstraint constraintWithItem:imagePickerTar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *imagePickerTarBottom = [NSLayoutConstraint constraintWithItem:imagePickerTar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *imagePickerTarHeight = [NSLayoutConstraint constraintWithItem:imagePickerTar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
    [self.view addConstraints:@[imagePickerTarLeft, imagePickerTarRight,imagePickerTarBottom,imagePickerTarHeight]];
    _imagePickerTar = imagePickerTar;
    _imagePickerTar.delegate = self;
}
- (void)setAssetsFetchResults:(PHFetchResult *)assetsFetchResults
{
    _assetsFetchResults = assetsFetchResults;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i< assetsFetchResults.count; i++)
    {
        XXBPhotoModel *photoModel = [[XXBPhotoModel alloc] init];
        photoModel.asset = assetsFetchResults[i];
        [array addObject:photoModel];
    }
    self.photoModleArray = [array copy];
    [self.collectionView reloadData];
}
#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
        if (collectionChanges) {
            self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
            UICollectionView *collectionView = self.collectionView;
            if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves])
            {
                [collectionView reloadData];
                
            }
            else
            {
                [collectionView performBatchUpdates:^{
                    NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                    if ([removedIndexes count])
                    {
                        [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                    NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                    if ([insertedIndexes count]) {
                        [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                    NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                    if ([changedIndexes count]) {
                        [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                } completion:NULL];
            }
        }
    });
}
#pragma mark - XXBImagePickerTabrDelegate

- (void)imagePickerTabrFinishClick
{
#warning todo 通知父控件点击了完成按钮
}
#pragma mark - UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XXBPhotoCollectionFootView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        
        reusableview = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier forIndexPath:indexPath];
        reusableview.photoCount = self.photoModleArray.count;
    }
    return reusableview;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.photoModleArray.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCollectionViewCell forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.photoModel = self.photoModleArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBPicShowViewController *picShowViewController = [[XXBPicShowViewController alloc] init];
    picShowViewController.assetsFetchResults = self.assetsFetchResults;
    picShowViewController.index = indexPath.row;
    [self.navigationController pushViewController:picShowViewController animated:YES];
}
- (void)photoCollectionViewCellSelectButtonDidclick:(XXBPhotoCollectionViewCell *)photoCollectionViewCell
{
    XXBPhotoModel *photoModel = photoCollectionViewCell.photoModel;
    NSInteger index = [self.selectPhotoModels indexOfObject:photoModel];
    if (index != NSNotFound)
    {
        /**
         *  没有找到就删除
         */
        photoModel.index = 0;
        [self.selectPhotoModels removeObjectAtIndex:index];
        NSInteger count = self.selectPhotoModels.count;
        for (NSInteger i = index; i < count; i++)
        {
            XXBPhotoModel *photoModel = self.selectPhotoModels[i];
            photoModel.index -- ;
        }
    }
    else
    {
        /**
         *  找到之后加入选择的数组里边
         */
        [self.selectPhotoModels addObject:photoModel];
        photoModel.index = self.selectPhotoModels.count;
    }
    [self.collectionView reloadData];
    self.imagePickerTar.selectCount = self.selectPhotoModels.count;
}
#pragma mark - 添加照片
- (void)handleAddButtonItem:(id)sender
{
//    // Create a random dummy image.
//    CGRect rect = rand() % 2 == 0 ? CGRectMake(0, 0, 400, 300) : CGRectMake(0, 0, 300, 400);
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0f);
//    [[UIColor colorWithHue:(float)(rand() % 100) / 100 saturation:1.0 brightness:1.0 alpha:1.0] setFill];
//    UIRectFillUsingBlendMode(rect, kCGBlendModeNormal);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    // Add it to the photo library
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
//        
//        if (self.assetCollection) {
//            PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:self.assetCollection];
//            [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
//        }
//    } completionHandler:^(BOOL success, NSError *error) {
//        if (!success) {
//            NSLog(@"Error creating asset: %@", error);
//        }
//    }];
}
@end
