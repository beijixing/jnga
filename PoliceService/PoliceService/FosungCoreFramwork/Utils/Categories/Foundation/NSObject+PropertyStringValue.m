//
//  NSObject+PropertyStringValue.m
//  WoJK
//
//  Created by horse on 16/9/13.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "NSObject+PropertyStringValue.h"
#import <objc/runtime.h>
@implementation NSObject (PropertyStringValue)
- (void)setPropertyValuesForKeysWithDictionary:(NSDictionary *)dictionary {
    unsigned int outCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; ++i) {
        objc_property_t property = propertyList[i];
        //获取属性名
        const char *cName = property_getName(property);
        //将其转换成c字符串
        NSString *propertyName = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        [dictionary objectForKey:propertyName]?[self setValue:[dictionary objectForKey:propertyName] forKey:propertyName]:0;
       ;
    }
}
@end
