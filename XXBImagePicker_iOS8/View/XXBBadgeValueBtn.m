//
//  XXBBadgeValue.m
//  Pix72
//
//  Created by 杨小兵 on 15/6/2.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBBadgeValueBtn.h"
/**
 *  注意，左右会有一个像素的偏差，右边的需要比左边的少2
 */
#define marginLeft 5.5
#define marginRight 5.5

@implementation XXBBadgeValueBtn
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    self.hidden = YES;
    self.userInteractionEnabled = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    /**
     *  微调文字的位置
     */
    self.titleEdgeInsets = UIEdgeInsetsMake(0, marginLeft, 0, marginRight) ;
    UIImage *bgImage = [UIImage imageNamed:@"XXBImagePicker.bundle/XXBPageNumber"];
    [self setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width * 0.5 topCapHeight:bgImage.size.height * 0.5] forState:UIControlStateNormal];
}
- (void)setBageValue:(NSInteger)bageValue
{
    _bageValue = bageValue;
    if (_bageValue >0)
    {
        /**
         *  有值并且值不等于1 的情况向才进行相关设置
         */
        self.hidden = NO;
        if (_bageValue > 99)
        {
            _bageValue= 99;
        }
        NSString *bageString = [NSString stringWithFormat:@"%@",@(_bageValue)];
        [self setTitle:bageString forState:UIControlStateNormal];
        // 根据文字的多少动态计算frame
        CGRect frame = self.frame;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        CGFloat badgeW ;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = self.titleLabel.font;
        CGSize badgeSize =  [bageString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        badgeW = badgeSize.width + marginLeft +marginRight;        frame.size.width = badgeW + 1.0;
        frame.size.height = badgeH;
        self.frame = frame;
    }
    else
    {
        /**
         *  其他情况直接隐藏
         */
        self.hidden = YES;
    }
}
@end
