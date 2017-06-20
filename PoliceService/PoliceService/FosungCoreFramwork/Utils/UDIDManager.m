//
//  UDIDManager.m
//  WoJK
//
//  Created by Megatron on 16/4/20.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "UDIDManager.h"
#import "KeychainItemWrapper.h"

@implementation UDIDManager
+(NSString *)getUDID {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *keyIdentifier = [NSString stringWithFormat:@"%@_UDID", infoDict[@"CFBundleIdentifier"]];
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:keyIdentifier accessGroup:nil];
//    [keychin resetKeychainItem];
    NSString * udid = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([udid isEqualToString:@""]) {
        NSString *credential = [NSString stringWithFormat:@"%@_CREDENTIALS", keyIdentifier];
        [keychin setObject:credential forKey:(id)kSecAttrService];
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        udid = (__bridge_transfer NSString* )CFUUIDCreateString (kCFAllocatorDefault,uuidRef);
        [keychin setObject:udid forKey:(id)kSecValueData];
    }
    if ([udid containsString:@"-"]) {
       udid = [udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return udid;
}

+(NSString *)getTempUDID {
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *udid = (__bridge_transfer NSString* )CFUUIDCreateString (kCFAllocatorDefault,uuidRef);
    return udid;
}

@end
