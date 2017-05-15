//
//  APISign.m
//  PoliceService
//
//  Created by WenJie on 2017/5/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import "APISign.h"
#import <CommonCrypto/CommonDigest.h>
@implementation APISign
+ (NSDictionary *)paramSignedWithPagram:(NSDictionary *)pagram functionName:(NSString *)functionName
{
    NSMutableDictionary *dic = [pagram mutableCopy];
    [dic setObject:[APISign signWithPagram:pagram functionName:functionName] forKey:@"sign"];
    return dic;
}

+ (NSString *)signWithPagram:(NSDictionary *)pagram functionName:(NSString *)functionName{

    //拼接t：functionName
    NSMutableDictionary *pagramSort = [pagram mutableCopy];
    [pagramSort setObject:functionName forKey:@"t"];
    //字典排序
    NSArray *keys = [[pagramSort allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        unsigned char obj1_char = [obj1 characterAtIndex:0];
        unsigned char obj2_char = [obj2 characterAtIndex:0];
        if (obj1_char < obj2_char) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
        
    }];
    
    //字典转化为字符串
    NSMutableString *stringToSha1 = [@"" mutableCopy];
    for (NSString *key in keys) {
        [stringToSha1 appendFormat:@"&%@=%@",key,pagramSort[key]];
        
    }
    [stringToSha1 appendString:@"&signKey=egso1234566f46698e20b876020eaf2017ftd1"];
    [stringToSha1 replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    return [stringToSha1 sha1];
}
- (NSComparisonResult)sortParam:(NSString *)key{
    return NSOrderedAscending;
}
@end


@implementation NSString (SHA1)

- (NSString*) sha1
{
//    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (CC_LONG)(data.length), digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
