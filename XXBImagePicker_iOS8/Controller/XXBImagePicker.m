//
//  XXBImagePickerController.m
//  XXBImagePicker_iOS8
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "XXBImagePicker.h"
#import "XXBPhotoGroupViewController.h"

@interface XXBImagePicker ()
@property(nonatomic , strong)XXBPhotoGroupViewController *photoGroupViewController;
@end

@implementation XXBImagePicker
- (instancetype)init
{
    if (self = [super initWithRootViewController:self.photoGroupViewController])
    {
        
    }
    return self;
}
- (XXBPhotoGroupViewController *)photoGroupViewController
{
    if (_photoGroupViewController == nil)
    {
        _photoGroupViewController = [[XXBPhotoGroupViewController alloc] init];
    }
    return _photoGroupViewController;
}
@end
