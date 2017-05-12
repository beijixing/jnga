//
//  UICollectionViewFlowLayout+CollectionViewCellSpaceFix.h
//  PoliceService
//
//  Created by horse on 2017/2/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewFlowLayout (CollectionViewCellSpaceFix)
- (CGFloat)fixSlit:(CGRect)rect colCount:(CGFloat)colCount space:(CGFloat)space;
@end
