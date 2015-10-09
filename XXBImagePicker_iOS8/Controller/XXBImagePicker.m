//
//  XXBImagePickerController.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "XXBImagePicker.h"
#import "XXBPhotoGroupViewController.h"

@interface XXBImagePicker ()<XXBPhotoGroupViewControllerDelegate>
@property(nonatomic , strong)XXBPhotoGroupViewController *photoGroupViewController;
@end

@implementation XXBImagePicker
- (instancetype)init
{
    if (self = [super initWithRootViewController:self.photoGroupViewController])
    {
        [self p_setImagePick];
    }
    return self;
}
- (void)p_setImagePick
{
    
    self.showPage = YES;
    self.showAllPhoto = YES;
    self.photoCount = 99;
}
- (XXBPhotoGroupViewController *)photoGroupViewController
{
    if (_photoGroupViewController == nil)
    {
        _photoGroupViewController = [[XXBPhotoGroupViewController alloc] init];
        _photoGroupViewController.selectPhotoModels = self.selectPhotoModels;
        _photoGroupViewController.delegate = self;
    }
    return _photoGroupViewController;
}
- (void)photoGroupViewControllerCancleSelected:(XXBPhotoGroupViewController *)photoGroupView
{
    if ([self.imagePickerDelegate respondsToSelector:@selector(imagePickerControllerCancleselect:)])
    {
        [self.imagePickerDelegate imagePickerControllerCancleselect:self];
    }
}
#pragma mark ---
- (void)setShowPage:(BOOL)showPage
{
    _showPage = showPage;
    self.photoGroupViewController.showPage = _showPage;
}
- (void)setShowAllPhoto:(BOOL)showAllPhoto
{
    _showAllPhoto = showAllPhoto;
    self.photoGroupViewController.showAllPhoto = _showAllPhoto;
}
- (void)photoGroupViewController:(XXBPhotoGroupViewController *)photoGroupView didselectPhotos:(NSArray *)selectPhotos
{
    if ([self.imagePickerDelegate respondsToSelector:@selector(imagePickerController:didselectPhotos:)])
    {
        [self.imagePickerDelegate imagePickerController:self didselectPhotos:self.selectPhotoModels];
    }
}
- (NSMutableArray *)selectPhotoModels
{
    if(_selectPhotoModels == nil)
    {
        _selectPhotoModels = [NSMutableArray array];
    }
    return _selectPhotoModels;
}
@end
