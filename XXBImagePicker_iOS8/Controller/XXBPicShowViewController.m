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
#import "XXBPhotoModel.h"
@interface XXBPicShowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,XXBPicShowCollectionViewCellDelegate>
@property (strong) PHCachingImageManager            *imageManager;

@property(nonatomic , weak)UICollectionView         *collectionView;
@end

@implementation XXBPicShowViewController
static NSString *CellReuseIdentifier = @"XXBPicShowCollectionViewCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.photoGroupModel.photoModelArray.count > self.index)
    {
        NSIndexPath *indepath = [NSIndexPath indexPathForRow:self.index inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indepath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
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
- (void)setPhotoGroupModel:(XXBPhotoGroupModel *)photoGroupModel
{
    _photoGroupModel = photoGroupModel;
    [self.collectionView reloadData];
}
- (void)setIndex:(NSInteger)index
{
    _index = index;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoGroupModel.photoModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXBPicShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    XXBPhotoModel *photoModel = self.photoGroupModel.photoModelArray[indexPath.row];
    cell.asset = photoModel.asset;
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
@end
