//
//  UIView+CornerRadius.h
//  addCornerRadiusForAllXib
//
//  Created by 黄少华 on 15/12/28.
//  Copyright © 2015年 黄少华. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIView (CornerRadius)
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
@property (nonatomic, strong)IBInspectable UIColor *borderColor;
- (void)setBoderLeftWithOffset:(CGFloat)offset color:(UIColor*)color width:(CGFloat)width;
- (void)setBoderRightWithOffset:(CGFloat)offset color:(UIColor*)color width:(CGFloat)width;
@end
