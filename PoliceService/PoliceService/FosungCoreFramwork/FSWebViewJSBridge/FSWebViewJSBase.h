//
//  FSWebViewJSBase.h
//  FosungCore
//
//  Created by horse on 2017/1/19.
//  Copyright © 2017年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FSWVJBResponseCallback)(id responseData);
typedef void (^FSWVJBHandler)(id data, FSWVJBResponseCallback responseCallback);
