//
//  UIImage+CreateEmptyImage.m
//  PoliceApp
//
//  Created by horse on 16/9/26.
//  Copyright © 2016年 zgl. All rights reserved.
//

#import "UIImage+CreateEmptyImage.h"

@implementation UIImage (CreateEmptyImage)
+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
