//
//  NSAttributedString+WJAttribute.m
//  WeiCun4Manager
//
//  Created by 王文杰 on 16/5/23.
//  Copyright © 2016年 fosung. All rights reserved.
//

#import "NSAttributedString+WJAttribute.h"

@implementation NSAttributedString (WJAttribute)
+(instancetype)attributeStringWithArray:(NSArray *)strings
{
    NSMutableString *string = [NSMutableString new];
    [strings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendString:obj];
    }];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string];
    [strings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj;
        NSMutableDictionary *dic = [@{} mutableCopy];
        if (str.font) {
            [dic setObject:str.font forKey:NSFontAttributeName];
        }
        if (str.textColor) {
            [dic setObject:str.textColor forKey:NSForegroundColorAttributeName];
        }
        if (str.underLineCount) {
            [dic setObject:str.underLineCount forKey:NSUnderlineStyleAttributeName];
        }
        [attributeString setAttributes:dic range:[string rangeOfString:obj]];
    }];
    return attributeString;
}
@end
