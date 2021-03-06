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


@interface XXBPhotoCollectionViewController ()<XXBPhotoCollectionViewCellDelegate,XXBImagePickerTabrDelegate>
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
- (void)scrollToBottom
{
    if (self.photoGroupModel.photoModelArray.count == 0)
        return;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.photoGroupModel.photoModelArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}
#pragma mark - XXBImagePickerTabrDelegate

- (void)imagePickerTabrFinishClick
{
    [self.delegate photoCollectionViewController:self didselectPhotos:self.selectPhotoModels];
}
- (void)setPhotoGroupModel:(XXBPhotoGroupModel *)photoGroupModel
{
    _photoGroupModel = photoGroupModel;
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XXBPhotoCollectionFootView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        
        reusableview = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier forIndexPath:indexPath];
        reusableview.photoCount = self.photoGroupModel.photoModelArray.count;
    }
    return reusableview;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoGroupModel.photoModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCollectionViewCell forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.photoModel = self.photoGroupModel.photoModelArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBPicShowViewController *picShowViewController = [[XXBPicShowViewController alloc] init];
    picShowViewController.photoGroupModel = self.photoGroupModel;
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
