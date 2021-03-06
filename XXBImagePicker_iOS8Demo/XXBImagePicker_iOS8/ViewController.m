//
//  ViewController.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "ViewController.h"
#import "XXBImagePicker.h"
#import "MBProgressHUD+XXB.h"
#import "XXBPhotoModel.h"
#import <Photos/Photos.h>

@interface ViewController ()<XXBImagePickerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic , weak)UICollectionView *collectionView;

@property(nonatomic , strong)NSMutableArray *photoArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
}
- (void)setNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"openPhoto" style:UIBarButtonItemStylePlain target:self action:@selector(openPhoto)];
}
- (void)openPhoto
{
    // 创建一个照片选择器
    XXBImagePicker  *imagePickController = [[XXBImagePicker alloc] init];
    // 设置做多可选的照片数
    imagePickController.photoCount = 100;
    // 是都展示左上角的数字标签
    imagePickController.showPage = YES;
    //  是否默认打开全部相册
    imagePickController.showAllPhoto = YES;
    //  设置代理
    imagePickController.imagePickerDelegate = self;
    //  返回照片的排序方式
    imagePickController.photoSortType = XXBPhotoSortTypeSystemOrder;
    [self presentViewController:imagePickController animated:YES completion:^{
        
    }];
}
- (void)imagePickerControllerCancleselect:(XXBImagePicker *)imagePickController
{
    [imagePickController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerController:(XXBImagePicker *)imagePickController didselectPhotos:(NSArray *)selectPhotos
{
    [MBProgressHUD showMessage:@"正在加载照片" toView:self.collectionView];
    [self.photoArray removeAllObjects];
    [self.photoArray addObjectsFromArray:selectPhotos];
    [imagePickController dismissViewControllerAnimated:YES completion:^{
        [MBProgressHUD hideAllHUDsForView:self.collectionView animated:YES];
        [self.collectionView reloadData];
        [self.view bringSubviewToFront:self.collectionView];
    }];
}


#pragma mark - 返回的图片的链接的处理
- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 104);
        layout.minimumInteritemSpacing = 20;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(84, 10, 20, 10);
        UICollectionView *collectionView  = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor yellowColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.autoresizingMask = (1 << 6) -1;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
        imageView.image = [UIImage imageNamed:@"bg"];
        collectionView.backgroundView =imageView;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        _collectionView = collectionView;
        [self.view addSubview:collectionView];
        [self.view bringSubviewToFront:collectionView];
    }
    return _collectionView;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    cell.backgroundView = imageView;
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    XXBPhotoModel *photoModel = self.photoArray[indexPath.row];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // Download from cloud if necessary
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    [[PHImageManager defaultManager] requestImageDataForAsset:photoModel.asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        imageView.image = [UIImage imageWithData:imageData];
    }];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}
- (NSMutableArray *)photoArray
{
    if (_photoArray == nil)
    {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

@end
