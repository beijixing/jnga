//
//  NSString+WJAttribute.m
//  WeiCun4Manager
//
//  Created by 王文杰 on 16/5/23.
//  Copyright © 2016年 fosung. All rights reserved.
//

#import "NSString+WJAttribute.h"
#import "objc/runtime.h"

static  const char *WJFontKey = "WJFontKey";
static  const char *WJTextColorKey = "WJTextColorKey";
static  const char *WJUnderLineCountKey = "WJUnderLineCountKey";

@implementation NSString (WJAttribute)
- (void)setUnderLineCount:(NSNumber *)underLineCount{
    objc_setAssociatedObject(self, WJUnderLineCountKey, underLineCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)underLineCount
{
    return  objc_getAssociatedObject(self, WJUnderLineCountKey);
}
-(void)setFont:(UIFont *)font{
    objc_setAssociatedObject(self, WJFontKey, font, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIFont *)font{
    return  objc_getAssociatedObject(self, WJFontKey);
}

-(void)setTextColor:(UIColor *)textColor{
    objc_setAssociatedObject(self, WJTextColorKey, textColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

-(UIColor *)textColor{
    return  objc_getAssociatedObject(self, WJTextColorKey);
}
@end
