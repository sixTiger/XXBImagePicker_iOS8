//
//  XXBPicShowViewController.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/9/23.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import "XXBPicShowViewController.h"
#import <Photos/Photos.h>
#import "XXBPicShowView.h"
#import "XXBPicShowCollectionViewCell.h"

@implementation NSIndexSet (Convenience)
- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}
@end
@implementation UICollectionView (Convenience)
- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}
@end
@interface XXBPicShowViewController ()<PHPhotoLibraryChangeObserver,UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver,XXBPicShowCollectionViewCellDelegate>
@property (strong) PHCachingImageManager            *imageManager;

@property(nonatomic , weak)UICollectionView *collectionView;
@end

@implementation XXBPicShowViewController
static NSString *CellReuseIdentifier = @"XXBPicShowCollectionViewCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.assetsFetchResults.count > self.index)
    {
        NSIndexPath *indepath = [NSIndexPath indexPathForRow:self.index inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indepath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}
- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}
- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        CGFloat padding = 5;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding);
        CGFloat itemWidth = self.view.bounds.size.width;
        CGFloat itemHeight = self.view.bounds.size.height;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = padding * 2;
        UICollectionView *collectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(-padding, 0, itemWidth + padding * 2, itemHeight) collectionViewLayout:layout];
        [self.view addSubview:collectionView];
        collectionView.autoresizingMask = (1 << 6) - 1;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        [collectionView registerClass:[XXBPicShowCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (void)setAssetsFetchResults:(PHFetchResult *)assetsFetchResults
{
    _assetsFetchResults = assetsFetchResults;
    [self.collectionView reloadData];
}
- (void)setIndex:(NSInteger)index
{
    _index = index;
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
            
            [self resetCachedAssets];
        }
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBPicShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    cell.asset = asset;
    cell.delegate = self;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)picShowCollectionViewCellSingletap:(XXBPicShowCollectionViewCell *)picShowCollectionViewCell
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}
#pragma mark - Asset Caching

- (void)resetCachedAssets
{
    [self.imageManager stopCachingImagesForAllAssets];
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    return assets;
}
@end
