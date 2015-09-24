//
//  XXBPicShowView.h
//  Pix72
//
//  Created by 杨小兵 on 15/5/24.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXBPicShowView;

@protocol XXBPicShowViewDelegate <NSObject>
@optional
- (void)picShowViewSingletap:(XXBPicShowView *)picShowView;

@end

@interface XXBPicShowView : UIScrollView
/**
 *  要展示的图片
 */
@property(nonatomic , strong)UIImage *image;
@property(nonatomic , weak)id<XXBPicShowViewDelegate> picShowViewdelegate;
@end
