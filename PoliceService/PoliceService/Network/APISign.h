//
//  APISign.h
//  PoliceService
//
//  Created by WenJie on 2017/5/14.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>
/**接口加密*/
@interface APISign : NSObject
+ (NSDictionary *)paramSignedWithPagram:(NSDictionary *)pagram functionName:(NSString *)functionName;
@end

@interface NSString (SHA1)
- (NSString*) sha1;
@end
