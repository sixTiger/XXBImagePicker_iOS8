//
//  XXBPhotoGroupViewController.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "XXBPhotoGroupViewController.h"
#import "XXBImagePickerTableViewCell.h"
#import "XXBPhotoCollectionViewController.h"
@import Photos;
@interface XXBPhotoGroupViewController ()<PHPhotoLibraryChangeObserver>
@property(nonatomic , strong) NSArray *collectionsFetchResults;
@property(nonatomic , strong) NSArray *collectionsLocalizedTitles;
@property(nonatomic , strong) XXBPhotoCollectionViewController *photoCollectionViewController;

@property (strong) PHCachingImageManager *imageManager;
@end

@implementation XXBPhotoGroupViewController
- (instancetype)init
{
    if (self = [super init])
    {
        [self p_setup];
    }
    return self;
}
- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}
- (void)p_setup
{
    [self setupItems];
    self.tableView.rowHeight = 60;
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:option];
    self.collectionsFetchResults = @[smartAlbums, topLevelUserCollections];
    [self p_excludeEmptyCollections];
    self.collectionsLocalizedTitles = @[NSLocalizedString(@"Smart Albums", @""), NSLocalizedString(@"Albums", @"")];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}
- (void)setupItems
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(p_cancleSelectPhotos)];
}
- (void)p_cancleSelectPhotos
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - tableView的相关操作

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.collectionsFetchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (section == 0)
    {
        numberOfRows = 1;
    }
    else
    {
        numberOfRows = [self.collectionsFetchResults[section - 1] count];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXBImagePickerTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    if (cell == nil)
    {
        cell = [[XXBImagePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PhotoCell"];
    }
    if (indexPath.section == 0)
    {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
       PHFetchResult *countResult = [PHAsset fetchAssetsWithOptions:options];
        cell.title = @"所有照片";
        cell.subTitle = [NSString stringWithFormat:@"%@",@(countResult.count)];
        PHAsset *asset = [countResult lastObject];
        self.imageManager = [[PHCachingImageManager alloc] init];
        CGSize AssetGridThumbnailSize = CGSizeMake(80, 80);
        [self.imageManager requestImageForAsset:asset
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      cell.iconImage = result;
                                  }];

    }
    else
    {
        PHAssetCollection *assetCollection = self.collectionsFetchResults[indexPath.section -1 ][indexPath.row];
        cell.title = assetCollection.localizedTitle;
        PHFetchResult *countResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        cell.subTitle = [NSString stringWithFormat:@"%@",@(countResult.count)];
        PHAsset *asset = [countResult lastObject];
        self.imageManager = [[PHCachingImageManager alloc] init];
        CGSize AssetGridThumbnailSize = CGSizeMake(80, 80);
        [self.imageManager requestImageForAsset:asset
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      cell.iconImage = result;
                                      
                                  }];
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *updatedCollectionsFetchResults = nil;
        for (PHFetchResult *collectionsFetchResult in self.collectionsFetchResults)
        {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            if (changeDetails)
            {
                if (!updatedCollectionsFetchResults)
                {
                    updatedCollectionsFetchResults = [self.collectionsFetchResults mutableCopy];
                }
                [updatedCollectionsFetchResults replaceObjectAtIndex:[self.collectionsFetchResults indexOfObject:collectionsFetchResult] withObject:[changeDetails fetchResultAfterChanges]];
            }
        }
        if (updatedCollectionsFetchResults) {
            self.collectionsFetchResults = updatedCollectionsFetchResults;
            [self.tableView reloadData];
        }
        
    });
}
/**
 *  对相册进行优化排序
 */
- (void)p_excludeEmptyCollections {
    NSMutableArray *collectionsArray = [NSMutableArray array];
    for (PHFetchResult *result in self.collectionsFetchResults)
    {
        NSMutableArray *filteredCollections = [NSMutableArray array];
        [result enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL *stop) {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            /**
             *  只要照片
             */
            [options setPredicate:[NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage]];
            PHFetchResult *countResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            if (countResult.count > 0)
            {
                if (!([assetCollection.localizedTitle isEqualToString:@"All Photos"] || [assetCollection.localizedTitle isEqualToString:@"所有照片"]))
                {
                    [filteredCollections addObject:assetCollection];
                    NSLog(@"%@",assetCollection.localizedTitle);
                }
            }
        }];
        if (filteredCollections.count > 0)
        {
            [collectionsArray addObject:filteredCollections];
        }
    }
    self.collectionsFetchResults = collectionsArray;
}
#pragma mark
@end
