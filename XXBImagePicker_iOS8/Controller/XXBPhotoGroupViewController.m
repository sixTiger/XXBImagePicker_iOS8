//
//  XXBPhotoGroupViewController.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "XXBPhotoGroupViewController.h"
#import "XXBPhotoGroupTableViewCell.h"
#import "XXBPhotoCollectionViewController.h"
#import <Photos/Photos.h>
#import "XXBPhotoGroupModel.h"
@interface XXBPhotoGroupViewController ()<PHPhotoLibraryChangeObserver,XXBPhotoCollectionViewControllerDelegate>
{
    NSInteger _photoInRow;
}
/**
 *  相册组 只存放资源文件
 */
@property(nonatomic , strong) NSArray                                   *photoSectionArray;

/**
 *  相册组 存放的XXBPhotoModel
 */
@property(nonatomic , strong) NSMutableArray                            *photoSectionModelArray;
/**
 *  像个每一个section的标题
 */
@property(nonatomic , strong) NSArray                                   *photoSectionTitles;
/**
 *  相册的选择的collectionViewController
 */
@property(nonatomic , strong) XXBPhotoCollectionViewController          *photoCollectionViewController;
/**
 *  相册的管理者
 */
@property (strong) PHCachingImageManager                                *imageManager;
/**
 *  没有编辑的相册分组的相关信息
 */
@property(nonatomic , strong)NSArray                                    *photoRealSectionArray;

@end

@implementation XXBPhotoGroupViewController
static NSString *photoGroupViewCellID = @"XXBPhotoGroupViewCellID";
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
    [self p_excludeEmptyCollections];
    [self p_creatPhotoSectionModelArray];
    [self.tableView registerClass:[XXBPhotoGroupTableViewCell class] forCellReuseIdentifier:photoGroupViewCellID];
    self.tableView.rowHeight = 60;
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.photoSectionTitles[section];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.photoSectionModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photoSectionModelArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXBPhotoGroupTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:photoGroupViewCellID];
    XXBPhotoGroupModel *photoGroupModel = self.photoSectionModelArray[indexPath.section ][indexPath.row];
    cell.assetCollection = photoGroupModel.assetCollection;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.photoCollectionViewController.photoGroupModel = self.photoSectionModelArray[indexPath.section ][indexPath.row];
    [self.navigationController pushViewController:self.photoCollectionViewController animated:YES];
}
#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *updatedCollectionsFetchResults = nil;
        for (PHFetchResult *collectionsFetchResult in self.photoRealSectionArray)
        {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            if (changeDetails)
            {
                if (!updatedCollectionsFetchResults)
                {
                    updatedCollectionsFetchResults = [self.photoRealSectionArray mutableCopy];
                }
                [updatedCollectionsFetchResults replaceObjectAtIndex:[self.photoRealSectionArray indexOfObject:collectionsFetchResult] withObject:[changeDetails fetchResultAfterChanges]];
            }
        }
        if (updatedCollectionsFetchResults)
        {
            self.photoRealSectionArray = updatedCollectionsFetchResults;
            [self p_excludeEmptyCollections];
            [self.tableView reloadData];
        }
        
    });
}
/**
 *  对相册进行优化排序
 */
- (void)p_excludeEmptyCollections
{
    NSMutableArray *photoSectionArray = [NSMutableArray array];
    for (PHFetchResult *result in self.photoRealSectionArray)
    {
        NSMutableArray *filteredCollections = [NSMutableArray array];
        [result enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL *stop)
         {
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
                 }
             }
         }];
        if (filteredCollections.count > 0)
        {
            [photoSectionArray addObject:filteredCollections];
        }
    }
    
    self.photoSectionArray = photoSectionArray;
}
- (void)p_creatPhotoSectionModelArray
{
    [self.photoSectionModelArray removeAllObjects];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    /**
     *  只要照片
     */
    [options setPredicate:[NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage]];
    PHFetchResult *countResult = [PHAsset fetchAssetsWithOptions:options];
    PHAssetCollection *assetCollection = [PHAssetCollection transientAssetCollectionWithAssetFetchResult:countResult title:@"所有照片"];
    NSMutableArray *section_0 = [NSMutableArray array];
    XXBPhotoGroupModel *photoGroupModel = [[XXBPhotoGroupModel alloc] init];
    photoGroupModel.assetCollection = assetCollection;
    [section_0 addObject:photoGroupModel];
    [self.photoSectionModelArray addObject:section_0];
    
    for (PHFetchResult *assetsFetchResults in _photoSectionArray)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i< assetsFetchResults.count; i++)
        {
            XXBPhotoGroupModel *photoGroupModel = [[XXBPhotoGroupModel alloc] init];
            photoGroupModel.assetCollection = assetsFetchResults[i];
            [array addObject:photoGroupModel];
        }
        [self.photoSectionModelArray addObject:array];
    }
}
#pragma mark - XXBPhotoCollectionViewControllerDelegate
- (void)photoCollectionViewController:(XXBPhotoCollectionViewController *)photoCollectionViewController didselectPhotos:(NSArray *)selectPhotos
{
    [self.delegate photoGroupViewController:self didselectPhotos:self.selectPhotoModels];
}
- (void)photoCollectionViewControllerCancleSelected:(XXBPhotoCollectionViewController *)photoCollectionViewController
{
    [self.delegate photoGroupViewControllerCancleSelected:self];
}
- (NSMutableArray *)photoSectionModelArray
{
    if (_photoSectionModelArray == nil)
    {
        _photoSectionModelArray = [NSMutableArray array];
    }
    return _photoSectionModelArray;
}
#pragma mark - 懒加载
- (void)setSelectPhotoModels:(NSMutableArray *)selectPhotoModels
{
    _selectPhotoModels = selectPhotoModels;
    self.photoCollectionViewController.selectPhotoModels = _selectPhotoModels;
}
- (void)setPhotoInRow:(NSInteger)photoInRow
{
    _photoInRow = photoInRow;
    _photoCollectionViewController = nil;
}

- (NSInteger)photoInRow
{
    if (_photoInRow == 0)
    {
        if ([self isIpad])
        {
            _photoInRow = 6;
        }
        else
        {
            _photoInRow = 4;
        }
    }
    return _photoInRow;
}
- (XXBPhotoCollectionViewController *)photoCollectionViewController
{
    if (_photoCollectionViewController == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat screenWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        layout.minimumInteritemSpacing = 4;
        layout.minimumLineSpacing = 4;
        CGFloat itemWidth = (screenWidth - layout.minimumInteritemSpacing)/(CGFloat)self.photoInRow - layout.minimumInteritemSpacing;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.sectionInset = UIEdgeInsetsMake(layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumLineSpacing, layout.minimumInteritemSpacing);
        layout.footerReferenceSize = CGSizeMake(300.0f, 50.0f);
        _photoCollectionViewController  = [[XXBPhotoCollectionViewController alloc] initWithCollectionViewLayout:layout];
        _photoCollectionViewController.delegate = self;
    }
    return _photoCollectionViewController;
}
/**
 *  判断是否是ipad
 *
 *  @return YES 是
 */
- (BOOL)isIpad
{
    NSString* deviceType = [UIDevice currentDevice].model;
    return [deviceType rangeOfString:@"iPad"].length > 0;
}
- (NSArray *)photoRealSectionArray
{
    if (_photoRealSectionArray == nil)
    {
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:option];
        _photoRealSectionArray = @[smartAlbums, topLevelUserCollections];
    }
    return _photoRealSectionArray;
}
- (NSArray *)photoSectionTitles
{
    if (_photoSectionTitles == nil)
    {
        self.photoSectionTitles = @[@"所有照片",@"系统相册",@"个人相册"];
    }
    return _photoSectionTitles;
}
@end
