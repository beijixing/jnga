//
//  UIButton+FSEdgeInset.m
//  PoliceService
//
//  Created by WenJie on 2017/7/4.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "FSEdgeInsetButton.h"

@implementation FSEdgeInsetButton


-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    switch (self.compositionStyle) {
        case FSButtonCompositionStyleVerticalImageTitle:
            [self layoutWithStyleVerticalImageTitle];
            break;
        default:
            break;
    }
}


- (void)layoutWithStyleVerticalImageTitle
{
    CGFloat W = self.bounds.size.width;
    CGFloat H = self.bounds.size.height;
    CGFloat h_i = self.imageView.bounds.size.height;
    CGFloat W_t = W - 2 * self.horizontalEdgeSpace;
    CGFloat h_t = [self.titleLabel.text boundingRectWithSize:CGSizeMake(W_t, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size.height;
    self.imageView.center = CGPointMake(W/2, (H - h_t - self.imageTitleSpace)/2);
    self.titleLabel.frame = CGRectMake(self.horizontalEdgeSpace, (W + h_i + self.imageTitleSpace - h_t) / 2 , W - 2 * self.horizontalEdgeSpace, h_t);
    

}
@end
