//
//  XXBCollectionFootView.m
//  2015_02_03_XXBImagePicker
//
//  Created by 杨小兵 on 15/6/29.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBPhotoCollectionFootView.h"

@interface XXBPhotoCollectionFootView()
@property(nonatomic , weak)UILabel *countNumberLabel;
@end
@implementation XXBPhotoCollectionFootView
- (void)setPhotoCount:(NSInteger)photoCount
{
    _photoCount = photoCount;
    self.countNumberLabel.text = [NSString stringWithFormat:@"照片总数：%@",@(_photoCount)];
}
- (UILabel *)countNumberLabel
{
    if(_countNumberLabel == nil)
    {
        UILabel *countNumberLabel = [[UILabel alloc] initWithFrame:self.bounds];
        countNumberLabel.autoresizingMask = (1 << 6) - 1;
        countNumberLabel.textColor = [UIColor grayColor];
        countNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:countNumberLabel];
        _countNumberLabel = countNumberLabel;
    }
    return _countNumberLabel;
}
@end
