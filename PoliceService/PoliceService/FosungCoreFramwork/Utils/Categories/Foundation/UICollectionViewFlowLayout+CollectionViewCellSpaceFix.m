//
//  UICollectionViewFlowLayout+CollectionViewCellSpaceFix.m
//  PoliceService
//
//  Created by horse on 2017/2/22.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "UICollectionViewFlowLayout+CollectionViewCellSpaceFix.h"

@implementation UICollectionViewFlowLayout (CollectionViewCellSpaceFix)
- (CGFloat)fixSlit:(CGRect)rect colCount:(CGFloat)colCount space:(CGFloat)space {
    CGFloat totalSpace = (colCount - 1) * space;
    CGFloat itemWidth = (rect.size.width - totalSpace) / colCount;
    CGFloat realItemWidth = floor(itemWidth) + 0.5;
    if (realItemWidth < itemWidth) {
        realItemWidth += 0.5;
    }
    CGFloat realWdth = colCount * realItemWidth + totalSpace;
    CGFloat pointX = (realWdth - rect.size.width) / 2;
    rect.origin.x = -pointX;
    rect.size.width = realWdth;
    return (rect.size.width - totalSpace) / colCount;
}
@end
